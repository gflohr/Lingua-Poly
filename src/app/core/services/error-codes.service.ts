import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

// xgettext_noop().
const _ = (msg) => (msg);

// FIXME! This are not just errors but also messages.
export const ErrorCodes = {
	ERROR_REGISTRATION_FAILED: {
		title: _('Registration Failed'),
		text: _('Most probably the confirmation link has expired. Please try again!'),
	},
	ERROR_TOKEN_EXPIRED: {
		title: _('Token Expired'),
		text: _('The confirmation link has expired. Please try again!'),
	},
	ERROR_WEAK_PASSWORD: {
		title: _('Weak Password'),
		text: _('The password you have chosen is too weak!'),
	},
	ERROR_PASSWORD_CHANGE_FAILED: {
		title: _('Changing Password Failed'),
		text: _('Changing your password failed. Please try again later!'),
	},
	ERROR_NOT_LOGGED_IN: {
		title: _('Not Logged In'),
		text: _('You are not logged in. Please log in, before you proceed!'),
	},
	STATUS_PASSWORD_CHANGED: {
		title: _('Password Changed'),
		text: _('Password was successfully changed.'),
	},
};

export interface ErrorMessage {
	title: string,
	text: string,
};

@Injectable({
	providedIn: 'root'
})
export class ErrorCodesService {

	private codeSource = new BehaviorSubject(null);
	currentCode = this.codeSource.asObservable();

	constructor() { }

	message(code: string): ErrorMessage | null {
		if (ErrorCodes.hasOwnProperty(code)) {
			return ErrorCodes[code];
		} else {
			return null;
		}
	}

	changeCode(code: string) {
		this.codeSource.next(code);
	}
}
