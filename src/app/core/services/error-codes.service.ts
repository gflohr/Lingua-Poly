import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

// xgettext_noop().
const _ = (msg) => (msg);

export const ErrorCodes = {
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
