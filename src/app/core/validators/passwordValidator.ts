import { FormGroup } from '@angular/forms';
const zxcvbn = require('zxcvbn');

export class PasswordValidator {
	static passwordMatch(fg: FormGroup) {
		const password = fg.get('password');
		const password2 = fg.get('password2');

		if (!password.valid || !password2.valid) return null;

		return password.value !== password2.value ? { passwordMismatch: true} : null;
	}

	static passwordStrength(fg: FormGroup) {
		const password = fg.get('password');

		if (!password.valid) return null;

		const username = fg.get('username').value;
		const email = fg.get('email').value;

		console.log('username: ' + username);
		console.log('email: ' + email);
		const result = zxcvbn(password.value,
							  [username, email, 'lingua', 'poly',
							   'lingua-poly']);

		switch (result.score) {
			case 0:
				result.scoreDescription = "too guessable";
				break;
			case 1:
				result.scoreDescription = "very guessable";
				break;
			case 2:
				result.scoreDescription = "guessable";
				break;
			case 3:
				result.scoreDescription = "safely unguessable";
				break;
			default:
				result.scoreDescription = "very unguessable";
				break;
		}

		console.log(result);

		if (fg.get('passwordStrength').value !== result.scoreDescription) {
			fg.get('passwordStrength').setValue(result.scoreDescription);
		}

		if (result.score >= 3) return null;

		return {
			weakPassword: result
		};
	}
}
