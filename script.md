Welcome to my DataCamp audition video. My name is Kirill Müller, and today I'd like to show you reproducible workflows with the *drake* R package. I'm assuming some basic knowledge of the R language, in particular it helps if you understand how functions work in R. Knowledge of Make or similar tools is helpful, but not a preprequisite.

The *drake* package helps defining workflows. It allows you to encode the whole process of a data analysis as a set of data transformations. *drake* will figure out the order in which to apply the data transformations, and run the workflow. When you change the workflow, only what needs to be rebuilt will be rebuilt, everything else is reused from a previous run. This ensures reproducibility, you can always be sure that running the workflow from scratch will produce the same results. It also speeds up developing the analysis, because you don't need to think about which parts of your workflow to rerun, and because unnecessary work is skipped. If you encounter an error in an early part of the analysis, it's easy to fix at the source and rerun the entire workflow. Let's illustrate this with an example.

Here, we have a workflow graph of a simple analysis. The nodes are objects, the edges define the data flow between the objects. We have a file that contains the input dataset. We load it, do some very light data transformation, and then estimate a model and plot a histogram. *drake* generates this workflow graph from a plan, which in our example is constructed like this:

First, we load our packages

and define a helper function.

Then, we call `drake_plan()` with a series of commands: The command to load the data,

to transform the data,

to estimate the model

and to plot a histogram (with our helper function).

The plan is a data frame with two columns, `target` and `command`. Creating the plan only defines the workflow, it doesn't start any computation.

To actually run the workflow, we call `make()` with the plan. All targets are rebuilt, but if we call `make()` a second time, *drake* realizes that everything is up to date, and talks about it.

To show the results, we can use the `readd()` function to load individual targets. Here, we load the `model` target and show its summary. Targets can be complex R objects, and they are available as soon as you have run `make()` successfully on your plan.

To load multiple targets into our environment, we can use the `loadd()` function. Here, we load the data, and realize that we have an unwanted column. Let's fix it right away.

To do this, we modify the code in our plan. This alone doesn't change anything,

but when we run `make()` on the new plan, we see that the target is updated, and also its dependencies.

When we look at the `hist` target, we see a warning. Let's get rid of this problem too.

Here, the problem lies in a function we have defined. If we update the function and run the plan,

the histogram is updated, as we would have hoped. The warning is gone, the binwidth has been applied.

This is possible, because *drake* tracks not only the objects and the commands, but also the functions that are called as part of the commands. Each function used by a command becomes a prerequisite to the target computed by the command. If the function changes, the target is rebuilt.

We will continue with some exercises that will make you familiar with the most important functions of the *drake* package.
