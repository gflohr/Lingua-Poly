import { AbstractControl } from '@angular/forms';

export class PasswordValidator {
	static passwordMatch(control: AbstractControl) {
		const password = control.get('password').value;
		const password2 = control.get('password2').value;

		console.log(password + '<=>' + password2 + '?');
		return password !== password2 ? { PasswordMismatch: true} : null;
	}
}
