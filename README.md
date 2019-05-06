Step-by-step for testing
Create Scratch Org and push code
		- Connect to a dev org with DevHub enabled
		- sfdx force:project:create -n N26App
		- sfdx force:config:set defaultdevhubusername=yourdevorgalias -g
		- sfdx force:org:create -f config/project-scratch-def.json -a n26org
		- sfdx force:mdapi:convert -r unzipPackageDirectory
			- Copy git metadata to packageDirectory
		- sfdx force:source:push -u n26org
		- sfdx force:user:permset:assign -n N26_permission -u n26org
		- sfdx force:org:open -u n26org
		- Add custom setting value
			- Search for custom setting on home
			- Click on Manage on N26
			- Click on New
			- For ApiEndpoint add yourDomain + /services/data/v45.0/limits
		- Open RemoteSiteSettings on Home
			- Click New Remote Site
			- Add ApiEndpoint address and Save
		- Schedule running 
			- Execute Anonymous
			- N26DailyEmailSendScheduler.scheduleDaily('Daily Message');
		- Create Product Data like table shown in excel on github
		- Create Contact info with Product + Legal Country

Thanks