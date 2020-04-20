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
	STATUS_PASSWORD_RESET: {
		title: _('Password Reset'),
		text: _('Please check your mails!'),
	},
	ERROR_PASSWORD_RESET_FAILED: {
		title: _('Resetting Password Failed'),
		text: _('Resetting your password failed. Please try again later!'),
	},
	STATUS_ACCOUNT_DELETIION_SUCCESS: {
		title: _('Account Deleted'),
		text: _('Your account and all your personal data was successfully deleted.'),
	},
	ERROR_ACCOUNT_DELETION_FAILED: {
		title: _('Account Deletion Failed'),
		text: _('There was an error deleting your account. Please try again later'),
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
