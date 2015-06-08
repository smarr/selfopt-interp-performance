Tracing vs. Partial Evaluation: Comparing Meta-Compilation Approaches for Self-Optimizing Interpreters
======================================================================================================

[This repository](https://github.com/smarr/selfopt-interp-performance/tree/papers/metatracing-vs-partialevaluation)
contains the performance evaluation setup and measurement results for the
[Tracing vs. Partial Evaluation](http://stefan-marr.de/papers/oopsla-marr-ducasse-meta-tracing-vs-partial-evaluation-artifacts/submitted-draft.pdf)
paper currently under submission. The repository and its scripts are meant to
facilitate simple re-execution of the experiments to reproduce and verify the
performance numbers given in the paper.


1. Getting Started Guide
------------------------

The artifact is provided as a VirtualBox image. For separate source and data
downloads, please see section 3.

### 1.1 Download


 VirtualBox Image: [Mirror 1](http://stefan-marr.de/papers/oopsla-marr-ducasse-meta-tracing-vs-partial-evaluation-artifacts/artifact.tar.bz2)

 MD5 check sum: `FFFFFFFFFFFFFFFFFFFFFFFFFFFF` TODO


### 1.2 Setup Instructions

The VirtualBox image was created with version 4.3.28 available from
[virtualbox.org](https://www.virtualbox.org/wiki/Downloads).

The image contains a Lubuntu 15.04 installation:

 - username: mtvspe
 - password: mtvspe


### 1.3 Basic Experiment Execution and Data Analysis

Execute benchmarks (takes about 70h):

    `rebench rebench.conf`

Collect implementation size statistics:

    `scripts/patch-statistics.sh`

Generate report:

    `scripts/knit.R evaluation.Rmd`

The VirtualBox image starts up with a shell in the ~/experiments folder.
The benchmarks are executed by the [ReBench](https://github.com/smarr/ReBench) tool.

To run them, execute `rebench rebench.conf`. Executing all benchmarks takes
about 70 hours. It will create the file `data/benchmark.data`, however, it is
not directly used by the analysis scripts.

Note, ReBench gives a warning that the process' niceness cannot be set. To
reduce measurement errors, it is advisable to run with `sudo` so that the OS
scheduler does not interfere unnecessarily with the benchmarks.

The `scripts/patch-statistics.sh` script collects the implementation and change
sizes used in the evaluation and stores the results as `.csv` files in `data/`.

Based either on the supplied data or the newly generated data, a report can be
generated based on the `evaluation.Rmd` file. In case the benchmark data was
obtained running ReBench, note that the `data_file` variable in
`evaluation.Rmd` needs to be adjusted by removing the `.bz2` file extension.
The report will be stored in `evaluation.html`.


2. The Artifacts and Claims
---------------------------

The artifacts provided with our paper are intended to enable others to verify
that:

 - meta-tracing and partial evaluation reach similar performance
 - the impact of the different optimizations are as reported by the paper
 - the implementation sizes of the meta-tracing-based interpreters are
   generally smaller than their partial-evaluation-based counter parts
 - the used evaluation methodology is sound

Furthermore, we would like to recommend SOM as a dynamic language
implementation of very manageable size that reaches high performance and
therefore enables a wide range research experiments.

Further material on SOM:

 - [SOM (Simple Object Machine)](http://som-st.github.io/): A minimal Smalltalk for teaching of and research on Virtual Machines; a brief overview and scientific papers.
 - [SOM_PE, (aka TruffleSOM)](https://github.com/SOM-st/TruffleSOM/blob/master/README.md): SOM implemented with the Truffle framework; brief usage instructions
 - [SOM_MT, (aka RTruffleSOM)](https://github.com/SOM-st/RTruffleSOM/blob/master/README.md): SOM implemented with RPython; brief usage instructions


3. Step-by-Step Instructions to the Experiments
-----------------------------------------------

This section gives a more detailed overview of the setup and execution of the
experiments.


### 3.1 Download

In addition to the VirtualBox image (cf. 1.1), we also provide the elements of
the artifact as separate downloads.

 - experiment setup as defined by this git repository branch, cf. sec. 3.3
 - [original data set](http://stefan-marr.de/papers/oopsla-marr-ducasse-meta-tracing-vs-partial-evaluation-artifacts/data.tar.bz2)
   the raw data of our performance and implementation size measurements
 - [complete source tarball](http://stefan-marr.de/papers/oopsla-marr-ducasse-meta-tracing-vs-partial-evaluation-artifacts/source-snapshot.tar.bz2),
   a copy of all source of this repository and its submodules TODO


### 3.2 Software Dependencies

The general software requirements are as follows:

 - Python 2.7, for build tools and benchmark execution
 - C++ compiler (GCC or Clang), for RPython and Graal+Truffle
 - ReBench (>= 0.7.1), for benchmark execution
 - Java 7 and 8, for Graal and Truffle (Java 8u31 is a compatible Java 8 version)
 - git, to checkout the source repositories
 - libffi headers, for RPython
 - make and ant, for the compiling the experiments
 - PyPy, to compile the RPython-based experiments
 - pip and SciPy, for the ReBench benchmarking tool
 - R for generating the reports
 
On a Ubuntu-based system, the following packages should provide the required
software:

```bash
sudo apt-get install build-essential ant pypy libffi-dev pkg-config git \
     make ant python-pip python-scipy r-base

sudo pip install ReBench
```

A compatible JDK can be downloaded from the [Java SE 8 Archive](http://www.oracle.com/technetwork/java/javase/downloads/java-archive-javase8-2177648.html#jdk-8u31-oth-JPR).


### 3.3 Checkout Git Repository and Build Experiments

Our experiments are managed with git. We use submodules to track the versions
of the various branches and ensure that all experiments are built based on the
correct source code.

The setup for this paper is in the `papers/metatracing-vs-partialevaluation`
branch of the repository https://github.com/smarr/selfopt-interp-performance.

To checkout the repository:

```bash
git clone --recursive -b papers/metatracing-vs-partialevaluation https://github.com/smarr/selfopt-interp-performance mt-vs-pe
```

Note that the cloning can take a while since the repository contains about 20
experiments and larger submodules such as the Graal codebase. A full git clone
has a size of about 770MB currently.

To build all code artifacts switch to the `implementations` folder and execute
the `setup.sh` script or the separate `build-*.sh` files.

```bash
cd mt-vs-pe         # folder with the repository
cd implementations  # sources of the experiments, Graal, benchmarks, etc.
./setup.sh
```

Building all experiments can take multiple hours. Especially the compilation of
the RPython based experiments takes about 15min each. In case compilation fails
at any point, the `build-*.sh` files can be started manually. The
`build-rtrufflesom.sh` (for SOM_MT) and `build-trufflesom.sh` (for SOM_PE)
scripts loop over the experiments and execute the makefiles. In case something
goes wrong, it is helpful to comment out the `make clean` to avoid recompiling
everything.

**WARNING:** the `R-minimal-without-jit-annotations` experiment won't compile,
because it does not contain any jit-driver for RPython to indicate where
meta-tracing can start. The scripts are currently not robust enough to take this
into account automatically. Sorry for the inconvenience.


### 3.3 Execution of Experiments

To execute the benchmarks, we use the [ReBench](https://github.com/smarr/ReBench)
benchmarking tool. The experiments and all benchmark parameters are configured
in the `rebench.conf` file. The file has three main sections,
`benchmark_suites`, `virtual_machines`, and `experiments`. They describe the
settings for all experiments. Note that the names used in the configuration
file are post-processed for the paper in the R scripts used to generate graphs,
thus, the configuration contains all necessary information to find the
benchmark implementations in the repositories, but does not match exactly the
names in the paper.

Two important parameter to ReBench are the `-d` switch, which shows debug
output, and the `-N` switch which disables the use of the `nice` command to
increase the process priority of the benchmarks. The `-N` is only necessary
when root or sudo are not available.

To run the benchmarks:

```bash
cd mt-vs-le  # folder with the repository

sudo rebench -d rebench.conf  # runs with additional debug output
```

All benchmarks results are recorded in the `data/benchmark.data` file. The
benchmarks can be interrupted at any point and ReBench will later continue the
execution where it left off. However, the results of partial runs of one
virtual machine invocation are not recorded to avoid mixing up results from
before and after the warmup phases.

When executed in debug mode `-d` the output can be verbose. Most warnings can
be ignored as long as ReBench is able to obtain the benchmark results. If
however execution of experiments fails, the output will contain for instance
the used command line to run the experiments, which allows debugging the issue.

When not all experiments need to be execute for instance to verify the
performance of only a subset of them, one can comment out the experiment names
given in the `variable_values:` section of the corresponding benchmark suites.
Similarly, the benchmark set itself can also be reduced to a subset by
commenting out the corresponding lines in the `benchmarks:` section of a
benchmark suite.

To obtain the statistics about implementation size, the
`scripts/patch-statistics.sh` is used. It relies on the one hand on `git --diff
--shortstat` to determine the differences between the baseline branch and an
experiment. On the other hand, it uses the `cloc` tool, which is contained as a
copy in this repository. The script iterates over the experiments and outputs
the results into `*.csv` files in the `data/` folder.


### 3.4 Report Generation and Comparison

Before the results can be processed, a few R libraries have to be installed.
For this step R might require superuser rights. See `scripts/libraries.R` for
details.

```bash
sudo Rscript scripts/libraries.R
```

After the libraries have been installed, the actual report can be generated
by executing `scripts/knit.R evaluation.Rmd`. This will use the KnitR tool
to generate an HTML file from the markdown file with embedded R code.

The result should look like this [example](http://stefan-marr.de/papers/oopsla-marr-ducasse-meta-tracing-vs-partial-evaluation-artifacts/evaluation.html).
The report does not directly discuss the results. Please see the paper draft
for that. Instead, the report discusses how the results are evaluated to enable
future studies based on our results and evaluation.

Licensing
---------

The material in this repository is licensed under the terms of the MIT License.
Please note, the repository links in form of submodules to other repositories
which are licensed under different terms.
