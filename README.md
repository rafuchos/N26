Step-by-step for testing <br />
Create Scratch Org and push code <br />
	&nbsp;&nbsp;	- Connect to a dev org with DevHub enabled <br />
	&nbsp;&nbsp;	- sfdx force:project:create -n N26App <br />
	&nbsp;&nbsp;	- sfdx force:config:set defaultdevhubusername=yourdevorgalias -g <br />
	&nbsp;&nbsp;	- sfdx force:org:create -f config/project-scratch-def.json -a n26org <br />
	&nbsp;&nbsp;	- sfdx force:mdapi:convert -r unzipPackageDirectory <br />
	&nbsp;&nbsp;&nbsp;&nbsp;		- Copy git metadata to packageDirectory <br />
	&nbsp;&nbsp;	- sfdx force:source:push -u n26org <br />
	&nbsp;&nbsp;	- sfdx force:user:permset:assign -n N26_permission -u n26org <br />
	&nbsp;&nbsp;	- sfdx force:org:open -u n26org <br />
	&nbsp;&nbsp;	- Add custom setting value <br />
	&nbsp;&nbsp;&nbsp;&nbsp;		- Search for custom setting on home <br />
	&nbsp;&nbsp;&nbsp;&nbsp;		- Click on Manage on N26 <br />
	&nbsp;&nbsp;&nbsp;&nbsp;		- Click on New <br />
	&nbsp;&nbsp;&nbsp;&nbsp;		- For ApiEndpoint add yourDomain + /services/data/v45.0/limits <br />
	&nbsp;&nbsp;	- Open RemoteSiteSettings on Home <br />
	&nbsp;&nbsp;&nbsp;&nbsp;		- Click New Remote Site <br />
	&nbsp;&nbsp;		- Add ApiEndpoint address and Save <br />
	&nbsp;&nbsp;	- Schedule running  <br />
	&nbsp;&nbsp;&nbsp;&nbsp;		- Execute Anonymous <br />
	&nbsp;&nbsp;&nbsp;&nbsp;		- N26DailyEmailSendScheduler.scheduleDaily('Daily Message'); <br />
	&nbsp;&nbsp;	- Create Product Data like table shown in excel on github <br />
	&nbsp;&nbsp;	- Create Contact info with Product + Legal Country <br />
<br />
Thanks
