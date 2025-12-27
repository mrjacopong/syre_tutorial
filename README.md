[![DOI](https://img.shields.io/badge/DOI-10.5281/zenodo.18068584-blue)](https://doi.org/10.5281/zenodo.18068583)
[![View syre_tutorial on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://it.mathworks.com/matlabcentral/fileexchange/182919-syre_tutorial)
[![View on GitHub](https://img.shields.io/badge/github-repo-blue?logo=github)](https://github.com/mrjacopong/syre_tutorial)

# SyR-e Tutorial 

> A step-by-step, beginner-friendly guide to mastering synchronous machine design with SyR-e.

This tutorial demonstrates the SyR-e workflow using a **Surface Permanent Magnet (SPM)** motor as a primary case study. It covers the core tools that make this software essential for electric machine design, presented in an accessible format for newcomers.

### :dart: Key Learning Outcomes
By the end of this tutorial, you will be able to:

- **Model**: Import motor geometries and material characteristics into SyR-e.
- **Analyze**: Evaluate electrical characteristics via Finite Element Analysis (FEA), including torque, power, ripple, and flux linkages.
- **Map**: Generate and evaluate flux maps.
- **Optimize**: Refine motor geometry to meet specific performance targets via automatic optimizator.
- **Protect**: Evaluate maximum demagnetization current both analytically and through simulation.
- **Control**: Compute torque-speed characteristics, MTPA-MTPV (Maximum Torque Per Ampere / Voltage) control maps, and operational limits.
- **Simulate**: Build functional Simulink-Simscape models with actuators and control algorithms, ready for system-level testing.

## :hammer_and_pick: Prerequisites
- Basic understanding of synchronous electric machines and their control principles.
- Familiarity with the MATLAB and Simulink environments is expected.
> As a Power Electronics engineer myself, I have designed this tutorial to be accessible even if you aren't a dedicated "e-machine expert".


## :rocket: Getting Started

1. Download or clone this repository to your local machine (ideally within your SyR-e directory)
2. Follow the tutorial in `EM_design_W_SyRE_ONLINE.pdf`

## :open_file_folder: Dependencies

- **MATLAB** (2025b or later recommended)
- **SyR-e** — [GitHub](https://github.com/SyR-e/syre_public) | [MATLAB File Exchange](https://it.mathworks.com/matlabcentral/fileexchange/158216-syr-e)
- **FEMM** — [Download](https://www.femm.info/wiki/HomePage)

## :warning: Disclamer
This tutorial was developed by **[Jacopo Ferretti](https://orcid.org/0009-0003-7234-9957)** as part of his duties as a **MATLAB Student Ambassador**.<br>
> **Note on Bugfixes:** This tutorial includes specific workarounds for known issues. While these may be addressed in future SyR-e releases, they are included here to ensure a seamless experience for beginners.

If you encounter errors or require assistance, please feel free to open an issue or contact me directly!

## :raised_hands: Acknowledgments
- [Simone Ferrari](https://orcid.org/0000-0002-4100-1590) (PoliTO): Maintainer of SyR-e, for his invaluable feedback and technical support.
- [Paolo Panarese](https://github.com/paolo-panarese) (MathWorks): Supervisor of the Italian Student Ambassadors, for his guidance throughout the project.
- [Giacomo Sala](https://orcid.org/0000-0002-6374-7713) (UNIBO): Professor of "Electric Motor Design", for hosting me during his lecture and providing the opportunity to present this tutorial to his students.

## :page_facing_up: License

This work is licensed under the [Creative Commons Zero v1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/) (CC0 1.0) license. You are free to use, modify, and distribute this material without restriction.