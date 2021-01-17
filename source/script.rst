
Pipeline script
===============

A Nextflow pipeline script defines the computational pipeline based on a
*dataflow* model.

The basic unit is the **process** and different process are linked by
**channels**.

Process
-------

A process indicates how given an output, what to do to generate an output.

::

    process MyProcess {

        input:
            path input from INPUT

        output:
            path("*.copy") into COHORTS

        script:
            """
            cp ${input} ${input}.copy
            """
    }

``script``
  defines the command that is executed. The ``"""`` syntax allow to access
  Groovy variables with ``${x}``. In addition, groovy variables can be used
  before the actual script is called::

    script:
        name = input.baseName.split('\\.')[0]
        """
        cp ${input} ${name}.out
        """
		}

  It can also be conditional::

    if ( this == that ) {
        """
        do this
        """
    }
    else {
        """
        do that
        """
    }

  It is possible to add shell variables with ``\${SHELL_VAR}``
  when using double quotes, but the recommended approach is
  to define them in a separate script.
  Note that some variables (e.g. PATH) are defined also by nextflow,
  which can lead to errors.

``shell``
  similar to script but groovy variables can be accessed as '''!{var}'''

``input``
  section that has the channels the process is expecting to receive inputs data
  from

  Examples are::

    path input from INPUT
    tuple val(x), path(input) from TUPLES

  When multiple channels are used as inputs, items are taken in groups, one
  from each channel, until one channel is exhausted. If one channel is a
  value channel, it can be read unlimited times. More details in the
  `nextflow configuration <https://www.nextflow.io/docs/latest/process
  .html#understand-how-multiple-input-channels-work>`_.

``output``
  define the channels used by the process to send out the results

  E.g.::

    val x into OUT
    tuple val(cohort), path("*.out") into TUPLES
    stdout OUT2 // get the stdout of the process

  Multiple channels are allowed at once::

    path "*.out1" into OUT1
    path "*.out2" into OUT2

Directives
**********

Channels can have directives, and some might influence how the process work

``tag``
  identifier (using during run)

``label``
  identifier that can be used to select processes in the configuration

``publishDir``
  where to copy the results of the output channels

  ::

    publishDir "${FOLDER}/inputs", mode: "symlink", enabled: params.debug

``errorStrategy``
  defines what to do in case of error, ``'finish'``, ``'ignore'`` ...


Groovy constructs
*****************

Groovy functions, variables... can be used in your scripts. Some useful ones are

maps
  ::

    VALUES_MAP = ['1': 100]
    y = VALUES_MAP[x]

``error``
  raises and error::

    error "Error message"

ternary operator
  ::

    seedOpt = (params.seed == null)? '': "--seed ${params.seed}"


**Closures** ( ``{ }``) are functions as first class objects,
that have the ``it`` defined as the implicit argument of the closure.
The can be seen as a trick to assign a function to a variable.
The difference with a lambda expression is that it can access and modify global variables.


Channels
--------

Channels are the way that Nextflow uses to communicate between process. The
most important thing is that, except for value channels, they cannot be reused.
In case you want to use a channel in more than one process, make a copy::

    CHANNEL.into { COPY1; COPY2 }

As mentioned, value channels (which are restricted to one object)
can be used multiple times, but it doesn't mean
that what they hold can only be used as ``val``::

    VALUE = Channel.value("/path/to/file")

    process Demo {

        input:
            path input from INPUTS
            path same_file from VALUE

    }

The **fromFilePairs** method will not output the pairs in which one of the elements does not exits.

Operations
**********

Channels support a series of operations, than can be chained if needed.

``flatten``
  useful when a process outputs multiple files at once to put them in a
  single list

``map``
  transforms a channel. ``it`` represents each item in the channel

  ::

    CHANNEL.map{it -> [it.baseName.split('\\.')[0], it]}

``join``
  combine channels by key::

    C1 = Channel.from(['X', 1], ['Y', 2], ['Z', 3])
    C2 = Channel.from(['X', 1], ['Y', 2], ['Z', 3])
    tuple val(key), val(v1), val(v2) from C1.join(C2)

``collect``
  wait for all items of the channel and emit them at once

``mix`` ``grouTuple``
  combine channels

