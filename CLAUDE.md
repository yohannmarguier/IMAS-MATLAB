# Repository Guidelines

Any changes should be also reflected in AGENTS.md

## Project Structure & Module Organization

This is the MATLAB high-level interface to IMAS Access Layer. MATLAB entry points live in `matlab/`; their MEX implementations and shared C helpers are in `src/`. XSLT generators at the repository root and in `common/` generate IDS-specific sources from the IMAS Data Dictionary—edit generators rather than generated output where applicable. `tests/` contains MATLAB unit, integration, and performance tests; `examples/` contains runnable MATLAB examples. Sphinx documentation is in `doc/`, and CI and cluster scripts are in `ci/` and `.github/workflows/`.

## Build, Test, and Development Commands

MATLAB and a C/C++ toolchain are required. CMake fetches IMAS Core and the Data Dictionary unless configured for a local development layout.

```bash
cmake -B build --preset=https -DAL_BACKEND_HDF5=ON -DAL_TESTS=ON -DAL_EXAMPLES=ON
cmake --build build --parallel
ctest --test-dir build --output-on-failure
cmake --install build
```

The first command configures an HTTPS-based dependency checkout and enables the HDF5 test backend. The test command runs the CTest registrations, which invoke MATLAB's `runtests('imas_unit_tests')`. For documentation, use `ci/build_docs.sh` or configure with `-DAL_HLI_DOCS=ON -DAL_DOCS_ONLY=ON` and build the resulting tree. Do not commit build directories or generated local artifacts.

## Coding Style & Naming Conventions

Follow the surrounding file's formatting: MATLAB uses two-space indentation, `function` blocks, and lower-case underscore-separated API names such as `ids_get_slice`; C uses four-space indentation and lower-case underscore-separated filenames such as `imas_mex_utils.c`. Keep MATLAB help comments immediately above public functions and use established `IMAS:<component>:<condition>` error identifiers in MEX code. Prefer focused changes; preserve the generator/source relationship when changing IDS behavior.

## Testing Guidelines

Add coverage in the relevant `matlab.unittest.TestCase` class, using descriptive `test...` method names. Exercise both HDF5 and MDSplus only when the change is backend-specific; HDF5 is sufficient for the standard local path. Run the narrow MATLAB suite while iterating when the built libraries are on the path, then run CTest before opening a PR. Update examples or docs when public MATLAB behavior changes.

## Commit & Pull Request Guidelines

Recent history uses brief, imperative summaries (for example, `Fix warnings in windows`) and conventional prefixes for automation such as `ci:`. Use one focused change per commit; include the affected component when helpful. Start work from the latest `develop` branch, as required by `CONTRIBUTING.md`. PRs should describe the behavior change, link the agreed issue, list validation performed, and include MATLAB output or screenshots when they clarify a user-facing change.

## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

When the user types `/graphify`, use the installed graphify skill or instructions before doing anything else.

Rules:
- For codebase questions, first run `graphify query "<question>"` when graphify-out/graph.json exists. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- Dirty graphify-out/ files are expected after hooks or incremental updates; dirty graph files are not a reason to skip graphify. Only skip graphify if the task is about stale or incorrect graph output, or the user explicitly says not to use it.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).
