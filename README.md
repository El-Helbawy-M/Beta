# Git Rules 
### Git Branch naming convention:
* **Temporary Git branches**: <br>
Team members can create and delete these branches whenever it is required.
Different branch types:
* **Bug Fix**
* **Hot Fix**
* **Feature Branches**

<!--Commits convention:-->

### Commit Subject breakdown<br>
`type` (`scope`) : `title`

### Commit description breakdown<br>
=> `body` <br>
The desctiption...<br>
=> `footer`<br>
some text...

<hr/>

## Notes
*  Any line of the commit message cannot be longer than 100 characters! This allows the message to be easier to read on GitHub as well as in various git tools.

 
* If the commit reverts a previous commit, it should begin with `revert:` , followed by the title of the reverted commit. In the body it should say: This reverts commit <hash>, where the hash is the SHA of the commit being reverted. A commit with this format is automatically created by the git revert command.
<hr/>

## Commit types

* feat: The new feature you're adding to a particular application
* fix: A bug fix
* perf: A code change that improves performance
* style: Feature and updates related to UI styling
* refactor: Refactoring a specific section of the codebase
* test: Everything related to testing
* docs: Everything related to documentation
* chore: Changes to the build process or CI/CD or auxiliary tools and libraries such as documentation generation

<hr/>

*  Scope
    * The scope could be anything specifying the place of the commit change. For example cms, forms, engine, etc...
    * You can use when the change affects more than a single scope.

* Title
    * The title contains succinct description of the change
    * use the imperative, present tense: "change" not "changed" nor "changes"
    * don't capitalize first letter
    * no dot (.) at the end

* Body
    * Just as in the title, use the imperative, present tense: "change" not "changed" nor "changes". The body should include the motivation for the change and contrast this with previous behavior.
    * In pull request add the link to the (Jira, Trello, Notion) card related to the current changes

* Footer
    * The footer should contain any information about Breaking Changes and is also the place to reference GitHub issues that this commit closes.
    * Breaking Changes should start with the word BREAKING CHANGE: with a space or two newlines. The rest of the commit message is then used for this.

<hr>

## Example:

Subject:

> feat(forms): perform JWT authentication before form rendering
