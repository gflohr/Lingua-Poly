import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

// xgettext_noop().
const _ = (msg) => (msg);

const errorCodes = {
	ERROR_NO_EMAIL_PROVIDED: {
		msg: _('You did not give access to an email address.'),
		title: _('No Email Address'),
	},
	ERROR_GOOGLE_EMAIL_NOT_VERIFIED: {
		msg: _('Your email address is not yet verified. Please verify it in your Google account first.'),
		title: _('Email Not Verified'),
	},
};

export interface ErrorMessage {
	title: string,
	message: string,
};

@Injectable({
	providedIn: 'root'
})
export class ErrorCodesService {

	private codeSource = new BehaviorSubject(null);
	currentCode = this.codeSource.asObservable();

	constructor() { }

	message(code: string): ErrorMessage | null {
		if (errorCodes.hasOwnProperty(code)) {
			return errorCodes[code];
		} else {
			return null;
		}
	}

	changeCode(code: string) {
		this.codeSource.next(code);
	}
}
