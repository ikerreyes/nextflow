
CLI
====

To execute a nextflow script simply run:

.. code-block:: sh

    nextflow run <script>.nf



Flags
-----

``-resume``: uses the work directory and only re-executes the changed steps
``-profile``: select one of the profiles defined in the configuration

.. _cli params:

Params
------

``params`` is an object that holds pairs of key-values.
Values can be updated in the CLI with ``--<parameter> <value>``.

