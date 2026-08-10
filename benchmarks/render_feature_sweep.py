#!/usr/bin/env python3
import csv
import html
import pathlib
import sys


def load(path):
    rows = {}
    with path.open(newline="") as stream:
        for row in csv.DictReader(stream):
            rows[(row["config"], row["workload"])] = row
    return rows


def write_cycles(rows, output):
    workloads = ["predictor", "cache", "attention", "smoke"]
    width, row_height = 900, 92
    height = 92 + row_height * len(workloads)
    parts = [
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}">',
        '<rect width="100%" height="100%" fill="#10151c"/>',
        '<style>text{font-family:ui-monospace,monospace;fill:#e6edf3}.title{font-size:20px;font-weight:700}.label{font-size:14px}.value{font-size:12px}</style>',
        '<text class="title" x="24" y="34">CPU feature-configuration cycles</text>',
        '<rect x="515" y="17" width="14" height="14" rx="2" fill="#8b949e"/>',
        '<text class="value" x="537" y="28">No predictor, 1-entry queues</text>',
        '<rect x="515" y="42" width="14" height="14" rx="2" fill="#2f81f7"/>',
        '<text class="value" x="537" y="53">BTB/gshare, 4-entry queues</text>',
    ]
    for index, workload in enumerate(workloads):
        y = 87 + index * row_height
        minimum = int(rows[("minimum", workload)]["cycles"])
        maximum = int(rows[("maximum", workload)]["cycles"])
        scale = 620 / max(minimum, maximum)
        parts.append(f'<text class="label" x="24" y="{y + 16}">{html.escape(workload)}</text>')
        for offset, value, color in [
            (28, minimum, "#8b949e"),
            (54, maximum, "#2f81f7"),
        ]:
            bar_width = max(2, value * scale)
            parts.append(f'<rect x="150" y="{y + offset - 13}" width="{bar_width:.1f}" height="17" rx="3" fill="{color}"/>')
            parts.append(f'<text class="value" x="{158 + bar_width:.1f}" y="{y + offset}">{value:,} cycles</text>')
    parts.append('</svg>')
    output.write_text("\n".join(parts) + "\n")


def write_speedup(rows, output):
    workloads = ["predictor", "cache", "attention", "smoke"]
    width, height = 760, 390
    speedups = []
    for workload in workloads:
        minimum = int(rows[("minimum", workload)]["cycles"])
        maximum = int(rows[("maximum", workload)]["cycles"])
        speedups.append(minimum / maximum)
    ceiling = max(2.0, max(speedups) * 1.15)
    parts = [
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}">',
        '<rect width="100%" height="100%" fill="#10151c"/>',
        '<style>text{font-family:ui-monospace,monospace;fill:#e6edf3}.title{font-size:20px;font-weight:700}.label{font-size:14px}.value{font-size:14px;font-weight:700}</style>',
        '<text class="title" x="24" y="34">Maximum-feature speedup over minimum</text>',
        '<line x1="65" y1="330" x2="730" y2="330" stroke="#8b949e"/>',
    ]
    for index, (workload, speedup) in enumerate(zip(workloads, speedups)):
        x = 95 + index * 160
        bar_height = 245 * speedup / ceiling
        y = 330 - bar_height
        parts.append(f'<rect x="{x}" y="{y:.1f}" width="92" height="{bar_height:.1f}" rx="5" fill="#3fb950"/>')
        parts.append(f'<text class="value" x="{x + 46}" y="{y - 9:.1f}" text-anchor="middle">{speedup:.2f}x</text>')
        parts.append(f'<text class="label" x="{x + 46}" y="355" text-anchor="middle">{html.escape(workload)}</text>')
    parts.append('</svg>')
    output.write_text("\n".join(parts) + "\n")


def main():
    csv_path = pathlib.Path(sys.argv[1])
    result_dir = pathlib.Path(sys.argv[2])
    rows = load(csv_path)
    write_cycles(rows, result_dir / "feature_cycles.svg")
    write_speedup(rows, result_dir / "feature_speedup.svg")


if __name__ == "__main__":
    main()
