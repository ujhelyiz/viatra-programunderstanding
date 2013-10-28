viatra2-programunderstanding
============================

An implementation of the [Program Understanding case study][1] of TTC2011 in the EMF API of VIATRA2. The goal is to extract a state machine based on specific programming patterns used in a selected code base.

Some extensions are already implemented over the original specification:
 * A query-based derived feature describing a back-link to the originating JaMoPP Java model element.
 * A validation rule checking whether the model states all have a static method called `Instance`.

Requirements to try it out:
 * [EMF-IncQuery 0.8.0][2]
 * [VIATRA2 EMF API][3]
 * [JaMoPP and EMFText][4]

[1]: http://rvg.web.cse.unsw.edu.au/eptcs/paper.cgi?TTC2011.3
[2]: http://eclipse.org/incquery
[3]: http://wiki.eclipse.org/VIATRA2/EMF/Transformation_API
[4]: http://www.jamopp.org/index.php/JaMoPP
