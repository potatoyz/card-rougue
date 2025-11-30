<!--
Sync Impact Report:
- Version Change: [Template] -> 1.0.0 (Initial Ratification)
- Principles Established:
  - I. GDScript First
  - II. Code Standards & Style
  - III. Chinese Documentation
  - IV. Card Roguelike Core
  - V. Testability & Quality
- Template Updates:
  - .specify/templates/plan-template.md (⚠ pending language instruction)
  - .specify/templates/spec-template.md (⚠ pending language instruction)
  - .specify/templates/tasks-template.md (⚠ pending language instruction)
-->
# CardRougue Constitution

## Core Principles

### I. GDScript First
The project is built using GDScript. Use static typing (`:=`, `->`) wherever possible to ensure type safety and performance.

### II. Code Standards & Style
Adhere to the official GDScript style guide. Code must be clean, readable, and idiomatic. File headers must include copyright information: `# Copyright (c) potato`.

### III. Chinese Documentation (MANDATORY)
All documentation, including Specifications (Spec), Plans, and Tasks, MUST be written in Chinese (Simplified). Code comments should be concise and can be in English or Chinese, but documentation files are strictly Chinese.

### IV. Card Roguelike Core
The game design follows standard Roguelike Deckbuilder mechanics. Features should be modular (Cards, Enemies, Relics) to support the genre's extensibility.

### V. Testability & Quality
Although a game, logic should be separated from presentation where possible to allow for unit testing (using a framework like GUT if applicable, or ad-hoc tests).

## Development Workflow

All features follow the Specify -> Plan -> Implement cycle. All documentation artifacts generated in this cycle must correspond to Principle III (Chinese Language).

## Quality Gates

Code reviews must verify adherence to GDScript typing and copyright headers. Documentation reviews must verify the use of Chinese language.

## Governance

This Constitution is the supreme law of the project. Amendments require documentation, approval, and a version bump.

**Version**: 1.0.0 | **Ratified**: 2025-11-30 | **Last Amended**: 2025-11-30