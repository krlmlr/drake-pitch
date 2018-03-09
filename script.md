Welcome to my DataCamp audition video. My name is Kirill Müller, and today I'd like to show you reproducible workflows with the *drake* R package. I'm assuming some basic knowledge of the R language, in particular it helps if you understand how functions work in R. Prior knowledge of Make or similar tools is helpful, but not a *preprequisite. I will be using tidyverse packages in the examples, but you don't need to be deeply familiar with the tidyverse to understand the examples.

Here, we have a typical data science workflow. You could use a set of R scripts, or perhaps an *rmarkdown* file, to implement this workflow. Today I'd like to show you a workflow with the drake R package. The purpose of *drake* is to save time and ensure reproducibility in data science projects. With *drake*, you can declare the whole process of a data analysis as a set of data transformations, and *drake* will run the workflow for you in the correct order. Let's take a look at an example.

This is a workflow graph of a simple analysis. The nodes are objects, the edges define the data flow between the objects. We have a file that contains the input dataset. We load it, do some very light data cleaning, and then fit a model and plot a histogram. *drake* automatically generates this workflow graph from a plan, which in our example is constructed like this:

First, we load our packages

and define a helper function for plotting the data.

Then, we call `drake_plan()` to define the commands, and store the result of that call in the `plan` variable.

Inside `drake_plan()`, we have a command to load the data,

to transform the data,

to plot a histogram using our helper function,

and to fit the model.

The plan is a data frame with two columns, `target` and `command`. Creating the plan only defines the workflow, it doesn't start any computation.

To actually run the workflow, we call `make()` with the plan. It doesn't show an error, this means that all targets have been computed successfully. Because *drake* is now in charge of running the workflow, it has control over the targets. To inspect these targets after a successful run, we can use the `readd()` function. Here, we load the `fit` target and show its summary. Targets can be complex R objects, and they are available after `make()` has run successfully on your plan.

To load multiple targets into our environment, we can use the `loadd()` function. Here, we load the data and the histogram. When inspecting the data, we realize that we have a column created with the import process which we don't need. This is harmless, but it's still better to remove this column.

To do this, we modify the code in our plan. This doesn't compute anything,

but when we visualize the new plan, we see that *drake* considers the `data` target outdated, as well as the `fit` and `hist` targets. Again, this graph is created automatically from the new plan and from the information *drake* has recorded in the previous run.

When we run `make()` on the new plan, we see that the `data` target is updated, and also the targets that depend on `data`. When you change the workflow, only those targets affected by the change are recomputed, everything else is reused from a previous run. You can always be sure that running the workflow from scratch will produce the same results: your workflow is reproducible. If you find a mistake in an early part of the analysis, it's easy to fix at the source and to rerun the entire workflow.

Let's look at the `hist` target now. We see a warning, because we haven't specified the bin width or the number of bins. Also, the font size is way to small, and we don't really need the gray background. Let's get rid of these problems too.

Here, we need to fix a function we have defined. If we update the function and run the plan, the histogram is updated, as we would have hoped. The warning is gone, the binwidth and the theme have been applied. We have used exactly the same command as before, but *drake* has recognized that it does not need to spend time on targets that are not affected by our changes. You don't need to think about which parts of your workflow to rerun. This reduces the time that passes between subsequent runs of your workflow, and therefore speeds up developing the analysis.

How did *drake* see that the `hist` target needs to be rebuilt? This is possible, because *drake* tracks not only the objects and the commands, but also the functions that are called from the commands. Each function used by a command becomes a prerequisite to the target computed by the command. If the function changes, the target is recomputed.

We will continue with some exercises that will help you become familiar with the most important functions of the *drake* package.
