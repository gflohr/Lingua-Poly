import { AbstractControl, ValidationErrors } from '@angular/forms';

export class UsernameValidator {
	static username(control: AbstractControl): ValidationErrors | null {
		const name = control.value;

		if (!name.length) return null;

		if (name.charCodeAt(0) <= 32) return { space: true };
		if (name.charCodeAt(name.length - 1) <= 32) return { space: true };

		if (name.includes('/')) return { slash: true };
		if (name.includes('@')) return { atSign: true };
		if (name.includes(':')) return { colon: true };

		if (name.match(/^user-[0-9a-f]*$/i)) {
			return { reserved: true };
		}

		return null;
	}
}
