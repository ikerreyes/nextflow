
Configuration
=============

Nextflow configuration is built by combining multiple input sources, it can
passed with the ``-c`` option in the command line, or it is `searched in
different locations <https://www.nextflow.io/docs/latest/config
.html#configuration-file>`_, being :file:`nextflow.config` in the current
directory.
In addition, configuration files can include other configuration files.

The syntax is::

    name = value

.. important:: Characters are interpreted similar to a bash shell, 1 is an
    integer while '1' is a string.

Configuration setting can be organized into scopes::

    scope.name = value
    // or
    scope {
        name = value
    }


Some useful scopes are:


``params``
  parameters accessible in the pipeline script. Those can be
  overwritten by the :ref:`cli <cli params>`

``process``
  configuration for the processes in the pipeline.
  Processes can be selected using their name or a label

  ::

    process {
        // default values
        cpus = 1

        withLabel: core {
            cpus = 2
        }
    }



``manifest``
  metadata information
  ::

    manifest {
      description = 'My NF pipeline'
    }


``env``
  defines environment variables that are exported to the running
  environments

  ::

    env {
        ENV0 = "VALUE"
        ENV1 = params.env1  // use a value from parameters
        ENV2 = env.ENV1 + 'something' // use another ennvar
        BGDATA_OFFLINE = "$PATH"
    }

``executor``
  set the optional executor settings

  ::

    executor {
        name = 'slurm'
        queueSize = 25
    }

``profile``
  configuration attributes that can be activated/chosen when launching a
  pipeline execution. Useful to include other files with specific setting for
  the ``executor`` and/or ``processes``

  ::

    profiles {
        slurm {
            includeConfig 'config/slurm.conf'
        }
    }


``trace``
  configure the execution trace

  ::

    trace {
      enabled = true
      fields = 'process,task_id,name,attempt,status,exit,%cpu,vmem,rss,submit,start,complete,duration,realtime,rchar,wchar'
    }

``timeline``
  execution timeline report

  ::

    timeline {
      enabled = true
    }



Variables in the configuration file outside any scope can also be used then
within the scopes. E.g.::


    containersDir = "$PWD/containers"

    params {
       containers = containersDir
    }

    singularity {
        enabled = true
        cacheDir = params.containers
    }

In addition, within a scope, other values of the scope can be used. E.g.::

    outputFolder = "$PWD"
    params {
       output = outputFolder
       debugFolder = "${params.output}/debug"
    }


HowTos
------

Use singularity
***************

Configure the ``singularity`` scope and the point the processes to the
appropriate containers::

    singularity {
        enabled = true
        cacheDir = params.containers
    }

    process {
        withName: ProcessX {
            container = "file:///${singularity.cacheDir}/x.sif"
        }
    }

Change error strategy
*********************

::

    process {
        errorStrategy = (params.debug)? 'ignore' : 'terminate'
    }


Retry with more memory
**********************

To adapt the memory to the attempt number::

    memory { task.memory * task.attempt }
    errorStrategy 'retry'
    maxRetries 3


