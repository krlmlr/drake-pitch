Welcome to my DataCamp audition video. My name is Kirill Müller, and today I'd like to show you reproducible workflows with the *drake* R package. I'm assuming some basic knowledge of the R language, in particular it helps if you understand how to write a function in R. Prior knowledge of Make or similar tools is helpful, but not necessary. I will be using tidyverse packages in the examples, but you don't need to be deeply familiar with the tidyverse.

The *drake* R package is for you if you have too many (or too slow) R scripts in your analysis project, and you're looking for a better way to organize the code. Or if you encountered the situation that your *rmarkdown* document has too many heavy code chunks and is processed too slowly. The purpose of *drake* is to save time and ensure reproducibility when working on data science projects. You declare the whole process of a data analysis as a set of data transformations, and *drake* runs these in the correct order. I'll use a small example, I'm sure you will find it even more useful for larger projects.

This is *drake*'s notion of a workflow graph of a simple analysis. The nodes are R objects or files, we call them "targets". The edges define the data flow between these targets. We have a file that contains the input dataset. We load it, do some very light data cleaning, and then fit a model and plot a histogram, and finally present these results in a nice report. *drake* automatically generates this workflow graph from a plan, which in our example is constructed like this:

First, we load our packages

and define a helper function for plotting the data.

Then, we call `drake_plan()` to define the commands, and store the result of that call in the `plan` variable.

Inside `drake_plan()`, we have a command to load the data,

to transform the data,

to plot a histogram using our helper function,

to fit the model,

and to create a PDF version of our dynamic report from the `report.Rmd` file using the *rmarkdown* package.

The plan is a data frame with two columns, `target` and `command`. Creating the plan only defines the workflow, it doesn't start any computation.

To actually run the workflow, we call `make()` with the plan. It runs without error, this means that all targets have been computed successfully. Our report PDF is ready! Of course, for a project of this size, we could have written a single *rmarkdown* file and just knit it, but this doesn't scale well for larger projects or when using larger datasets.

Because *drake* is now in charge of running the workflow, it has control over the targets. To inspect these targets after a successful run, we can use the `readd()` function. Here, we load the `fit` target and show its summary. Targets can be complex R objects, and they are available after `make()` has successfully run your plan.

To load multiple targets into our environment, we can use the `loadd()` function. Here, we load the data and the histogram. When inspecting the data, we realize that the import process has created a column which we don't need. This is harmless, but it's still better to remove this column.

To do this, we modify the code in our plan. This doesn't compute anything,

but when we visualize the new plan, we see that *drake* considers the `data` target outdated, as well as the `fit` and `hist` targets and also the report PDF. Again, this graph is created automatically from the new plan and from the information *drake* has recorded in the previous run.

When we run `make()` on the new plan, we see that the `data` target is updated, and also the targets that depend on `data`. When you change the workflow, *drake* tries very hard to reuse existing results. Only those targets that are affected by a workflow change are recomputed. You can always be sure that running the workflow from scratch will produce the same results: your workflow is reproducible. If you find a mistake in an early part of the analysis, it's easy to fix at the source and to rerun the entire workflow.

Let's look at the `hist` target now. We see a warning, because we haven't specified the bin width or the number of bins. Also, the font size is way to small. Let's get rid of these problems too.

Here, we need to fix a function we have defined. If we update the function and run the plan,

the histogram is updated, as we would have hoped. We have used exactly the same command as before, and *drake* has recognized that it does not need to fit the model again, but needs to update the report PDF. All computation is performed separately from the report, we can always access all intermediate results.

How did *drake* see that the `hist` target needs to be rebuilt? This is possible, because *drake* tracks not only the objects and the commands, but also the functions that are called from the commands. Each function used by a command becomes a prerequisite to the target computed by the command. If the function changes, the target is recomputed. The same is true for the report: the `report.Rmd` file is also a prerequisite for the final report PDF, which will be recreated whenever the `report.Rmd` file is edited.

We will continue with some exercises that will help you become familiar with the most important functions of the *drake* package.
