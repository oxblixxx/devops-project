Succesfully signed on to Jenkins dashboard, navigate to manage jenkins>security>CSRF PROTECTION. Enable proxy compatibility, this prevents the `CRUMB ERROR`. Click apply and safe.

Return to dashboard, click on `new item`, create a new job/project and choose `freestyle project`, open the project, then navigate to configure. There are various ways to authenticate git with jenkins, but we will be authenticating with [pat_token](https://stackoverflow.com/questions/61105368/how-to-use-github-personal-access-token-in-jenkins). 

On your github page, go to settings>developer settings>personal access tokens>tokens(classic). Then generate a new token.

Return to your project dashboard on Jenkins, source code management is `git`. In the repository url, paste the github project url for `https` in this format

```
https://<pat_token>@github.com/oxblixxx/news-homepage-main.git
```

Set the branch, click on apply then save. Click n build now to run the build, this doesn't build anything but authenticates the git configured. Check the console if that was a success, congrats!

## SETUP AUTOMATIC BUILD
Click "Configure" your job/project and add update the configuration.

Configure triggering the job from GitHub webhook, under `build trigger` enable `GitHub hook trigger for GITScm polling`

This is a build trigger option that allows Jenkins to automatically trigger a build when changes are pushed to a GitHub repository.
  
Also configure "Post-build Actions" to archive all the files – files resulted from a build are called "artifacts".
  
The artifacts are stored on Jenkins server locally in this directory

  
```sh
ls /var/lib/jenkins/jobs/tooling_github/builds/<build_number>/archive/
```
  
Go to your repository page on github, go to the settings. Locate `webhooks`. Then add a webhook in this format.

```sh
http://<jenkins-server-public-ip-addr>:8080/github-webhook/
```

Make a changes in any file in your repo, commit it and return to your jenkins dashboard to see an automatic build. A build is triggered everytime there is a commit.





