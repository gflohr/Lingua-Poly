import { Component } from "@angular/core";

@Component({
	selector: 'bc-login-page',
	template: `
	<bc-login-form
		(submitted)="onSubmit($event)"
		[pending]="pending$ | async"
		[errorMessage]="error$ | async"
	></bc-login-form>
`,
	styles: []
})

export class LoginPageComponent {

}
