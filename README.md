# TelescopeMorphic
TelescopeMorphic is a connector to render Telescope visualization using Morphic UI framework.

## Install
To install this project, use the following script:

```Smalltalk
Metacello new
    	githubUser: 'TelescopeSt' project: 'TelescopeMorphic' commitish: 'master' path: 'src';
    	baseline: 'TelescopeMorphic';
    	onWarningLog;
		onUpgrade: [ :e | e useIncoming ];
    	load
```
