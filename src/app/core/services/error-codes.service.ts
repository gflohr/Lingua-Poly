import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

// xgettext_noop().
const _ = (msg) => (msg);

export const ErrorCodes = {
	ERROR_NO_EMAIL_PROVIDED: {
		title: _('No Email Address'),
		text: _('You did not give access to an email address.'),
	},
	ERROR_GOOGLE_EMAIL_NOT_VERIFIED: {
		title: _('Email Not Verified'),
		text: _('Your email address is not yet verified. Please verify it in your Google account first.'),
	},
	ERROR_REGISTRATION_FAILED: {
		title: _('Registration Failed'),
		text: _('Most probably the confirmation link has expired. Please try again!'),
	}
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
