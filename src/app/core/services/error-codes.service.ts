// xgettext_noop().
const _ = (msg) => (msg);

export const ErrorCodes = {};

ErrorCodes['ERROR_NO_EMAIL_PROVIDED'] = {
	msg: _('You did not give access to an email address.'),
	title: _('No Email Address'),
};
ErrorCodes['ERROR_GOOGLE_EMAIL_NOT_VERIFIED'] = {
	msg: _('Your email address is not yet verified. Please verify it in your Google account first.'),
	title: _('Email Not Verified'),
};
