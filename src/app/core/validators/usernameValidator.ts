import { FormGroup } from '@angular/forms';

export class UsernameValidator {
	static username(fg: FormGroup) {
		console.log('validating');
		const username = fg.get('username');

		if (!username.valid) return null;

		if (username.value.includes('/')) return { slash: true };
		if (username.value.includes('@')) return { atSign: true };

		return null;
	}
}
