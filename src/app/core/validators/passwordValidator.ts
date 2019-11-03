import { FormGroup } from '@angular/forms';

export class PasswordValidator {
	static passwordMatch(fg: FormGroup) {
		const password = fg.get('password');
		const password2 = fg.get('password2');

		console.log('touched: ' + password2.touched);
		if (!password.valid || !password2.valid) return null;

		return password.value !== password2.value ? { passwordMismatch: true} : null;
	}
}
