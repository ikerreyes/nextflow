
CLI
====

To execute a nextflow script simply run:

.. code-block:: sh

    nextflow run <script>.nf



Flags
-----

``-resume``: uses the work directory and only re-executes the changed steps
``-profile``: select one of the profiles defined in the configuration
``-process.echo``: useful for debugging purposes

.. _cli params:

Params
------

``params`` is an object that holds pairs of key-values.
Values can be updated in the CLI with ``--<parameter> <value>``
or with ``-params.<parameter> <value>`.

Lists can be passed separating values by comma
(e.g. ``-params.times 1,2,3``), but then
it must be tokenized (``params.times.tokenize(',')``).

