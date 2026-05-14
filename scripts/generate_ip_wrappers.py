#!/usr/bin/env python3
"""Generate flat-port AMD Vivado IP packager wrappers for src/*.sv modules."""
from __future__ import annotations

from dataclasses import dataclass
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRC_DIR = ROOT / "src"

SKIP_FILES = {
    "cb_filter_pkg.sv",
    "cdc_reset_ctrlr_pkg.sv",
    "cf_math_pkg.sv",
    "ecc_pkg.sv",
    "stream_intf.sv",
}


@dataclass(frozen=True)
class Port:
    direction: str
    data_type: str
    name: str

    @property
    def typedef_name(self) -> str:
        return f"__{self.name}_t"

    @property
    def internal_name(self) -> str:
        return f"__{self.name}"


def strip_comments(text: str) -> str:
    text = re.sub(r"/\*.*?\*/", lambda m: "\n" * m.group(0).count("\n"), text, flags=re.S)
    text = re.sub(r"//.*", "", text)
    return text


def find_matching(text: str, start: int, open_ch: str, close_ch: str) -> int:
    depth = 0
    i = start
    while i < len(text):
        ch = text[i]
        if ch == open_ch:
            depth += 1
        elif ch == close_ch:
            depth -= 1
            if depth == 0:
                return i
        i += 1
    raise ValueError(f"no matching {close_ch!r} found")


def split_top_level_commas(text: str) -> list[str]:
    parts: list[str] = []
    start = 0
    paren = bracket = brace = 0
    i = 0
    while i < len(text):
        ch = text[i]
        if ch == "(":
            paren += 1
        elif ch == ")":
            paren -= 1
        elif ch == "[":
            bracket += 1
        elif ch == "]":
            bracket -= 1
        elif ch == "{":
            brace += 1
        elif ch == "}":
            brace -= 1
        elif ch == "," and paren == bracket == brace == 0:
            parts.append(text[start:i])
            start = i + 1
        i += 1
    tail = text[start:]
    if tail.strip():
        parts.append(tail)
    return parts


def remove_leading_attrs(item: str) -> str:
    s = item.strip()
    while s.startswith("(*"):
        end = s.find("*)")
        if end == -1:
            break
        s = s[end + 2 :].strip()
    return s


def extract_param_name(item: str) -> str | None:
    s = remove_leading_attrs(item)
    m = re.match(r"(?:localparam|parameter)\s+", s)
    if not m or s.startswith("localparam"):
        return None
    rest = s[m.end() :].strip()
    if rest.startswith("type"):
        rest = rest[len("type") :].strip()
        m = re.match(r"([A-Za-z_$][\w$]*)", rest)
        return m.group(1) if m else None

    # The parameter name is the final identifier before the top-level assignment.
    left = split_top_level_commas(rest.split("=", 1)[0])[0].strip()
    names = re.findall(r"[A-Za-z_$][\w$]*", left)
    return names[-1] if names else None


def normalize_block(text: str) -> str:
    lines = [line.rstrip() for line in text.splitlines()]
    while lines and not lines[0]:
        lines.pop(0)
    while lines and not lines[-1]:
        lines.pop()

    normalized: list[str] = []
    previous_blank = False
    for line in lines:
        blank = not line.strip()
        if blank and previous_blank:
            continue
        normalized.append(line)
        previous_blank = blank
    return "\n".join(normalized)


def parse_port(item: str) -> Port:
    s = remove_leading_attrs(item)
    m = re.match(r"(?s)^(input|output)\b\s*(.*)$", s)
    if not m:
        raise ValueError(f"unsupported port declaration: {item!r}")

    direction = m.group(1)
    declaration = m.group(2).strip()
    declaration = declaration.split("=", 1)[0].strip()
    m = re.match(r"(?s)^(?P<data_type>.*?)(?P<name>[A-Za-z_$][\w$]*)\s*(?:\[[^\]]+\]\s*)*$", declaration)
    if not m:
        raise ValueError(f"could not parse port declaration: {item!r}")

    data_type = m.group("data_type").strip() or "logic"
    name = m.group("name")
    return Port(direction=direction, data_type=data_type, name=name)


def parse_ports(ports: str) -> list[Port]:
    return [parse_port(item) for item in split_top_level_commas(ports)]


def extract_module_header(text: str, expected_module: str) -> tuple[str, str, str, list[str], list[Port]]:
    clean = strip_comments(text)
    m = re.search(rf"(?m)^\s*module\s+{re.escape(expected_module)}\b", clean)
    if not m:
        raise ValueError(f"module {expected_module} not found")
    pos = m.end()

    preamble_start = pos
    while pos < len(clean) and clean[pos].isspace():
        pos += 1
    while pos < len(clean) and not clean.startswith("#", pos) and clean[pos] != "(":
        pos += 1
    preamble = clean[preamble_start:pos].strip()

    params = ""
    param_names: list[str] = []
    if clean.startswith("#", pos):
        pos += 1
        while pos < len(clean) and clean[pos].isspace():
            pos += 1
        if clean[pos] != "(":
            raise ValueError(f"expected parameter list in {expected_module}")
        end = find_matching(clean, pos, "(", ")")
        params = normalize_block(clean[pos + 1 : end])
        for item in split_top_level_commas(params):
            name = extract_param_name(item)
            if name and not item.strip().startswith("localparam"):
                param_names.append(name)
        pos = end + 1

    while pos < len(clean) and clean[pos].isspace():
        pos += 1
    if clean[pos] != "(":
        raise ValueError(f"expected port list in {expected_module}")
    end = find_matching(clean, pos, "(", ")")
    ports = normalize_block(clean[pos + 1 : end])
    return expected_module, preamble, params, param_names, parse_ports(ports)


def render_wrapper(module: str, preamble: str, params: str, param_names: list[str], ports: list[Port], source_name: str) -> str:
    wrapper = f"{module}_wrapper"
    lines = [
        "// Copyright 2018 ETH Zurich and University of Bologna.",
        "// Copyright and related rights are licensed under the Solderpad Hardware",
        "// License, Version 0.51 (the \"License\"); you may not use this file except in",
        "// compliance with the License.  You may obtain a copy of the License at",
        "// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law",
        "// or agreed to in writing, software, hardware and materials distributed under",
        "// this License is distributed on an \"AS IS\" BASIS, WITHOUT WARRANTIES OR",
        "// CONDITIONS OF ANY KIND, either express or implied. See the License for the",
        "// specific language governing permissions and limitations under the License.",
        "",
        "// Auto-generated by scripts/generate_ip_wrappers.py; do not edit manually.",
        f"// AMD Vivado IP packager flat-port wrapper for `{module}` from `{source_name}`.",
    ]
    if params:
        if preamble:
            lines.append(f"module {wrapper}")
            lines.append(f"  {preamble}")
            lines.append(" #(")
        else:
            lines.append(f"module {wrapper} #(")
        lines.extend(line.rstrip() for line in params.splitlines())
        lines.append(") (")
    else:
        if preamble:
            lines.append(f"module {wrapper}")
            lines.append(f"  {preamble}")
            lines.append(" (")
        else:
            lines.append(f"module {wrapper} (")

    for idx, port in enumerate(ports):
        comma = "," if idx + 1 < len(ports) else ""
        lines.append(f"  {port.name}{comma}")
    lines.append(");")
    lines.append("")

    for port in ports:
        lines.append(f"  typedef {port.data_type} {port.typedef_name};")
    lines.append("")

    for port in ports:
        lines.append(f"  {port.direction} logic [$bits({port.typedef_name})-1:0] {port.name};")
    lines.append("")

    for port in ports:
        lines.append(f"  {port.typedef_name} {port.internal_name};")
    lines.append("")

    for port in ports:
        if port.direction == "input":
            lines.append(f"  assign {port.internal_name} = {port.typedef_name}'({port.name});")
        elif port.direction == "output":
            lines.append(f"  assign {port.name} = logic [$bits({port.typedef_name})-1:0]'({port.internal_name});")
        else:
            raise ValueError(f"unsupported port direction: {port.direction}")
    lines.append("")

    if param_names:
        lines.append(f"  {module} #(")
        for idx, name in enumerate(param_names):
            comma = "," if idx + 1 < len(param_names) else ""
            lines.append(f"    .{name} ( {name} ){comma}")
        lines.append(f"  ) i_{module} (")
    else:
        lines.append(f"  {module} i_{module} (")
    for idx, port in enumerate(ports):
        comma = "," if idx + 1 < len(ports) else ""
        lines.append(f"    .{port.name} ( {port.internal_name} ){comma}")
    lines.append("  );")
    lines.append("")
    lines.append("endmodule")
    lines.append("")
    return "\n".join(lines)


def main() -> None:
    generated = 0
    skipped: list[str] = []
    for path in sorted(SRC_DIR.glob("*.sv")):
        if path.name.endswith("_wrapper.sv"):
            continue
        module = path.stem
        if path.name in SKIP_FILES:
            skipped.append(path.name)
            continue
        text = path.read_text()
        if not re.search(rf"(?m)^\s*module\s+{re.escape(module)}\b", strip_comments(text)):
            skipped.append(path.name)
            continue
        mod, preamble, params, param_names, ports = extract_module_header(text, module)
        (SRC_DIR / f"{module}_wrapper.sv").write_text(render_wrapper(mod, preamble, params, param_names, ports, path.name))
        generated += 1
    print(f"generated {generated} wrapper files")
    if skipped:
        print("skipped non-module/interface/package files: " + ", ".join(skipped))


if __name__ == "__main__":
    main()
