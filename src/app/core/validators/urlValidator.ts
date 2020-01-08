import { AbstractControl, ValidationErrors } from '@angular/forms';

export class UrlValidator {
	static hostname(control: AbstractControl): ValidationErrors | null {
		if (!control.value.length) return null;

		try {
			const url = new URL(control.value);
			const valid = this.checkHostname(url);

			// We allow username and password as part of the URL.	It's stupid
			// by the user but why not?
			if (!valid) return { hostname: true };
		} catch(e) {
			return { hostname: true };
		}

		return null;
	}

	static scheme(control: AbstractControl): ValidationErrors | null {
		if (!control.value.length) return null;

		try {
			const url = new URL(control.value);
			if (!['https:', 'http:'].includes(url.protocol)) throw 'scheme';
		} catch(e) {
			throw 'scheme';
		}

		return null;
	}

	private static checkHostname(url: URL): boolean {
		const hostname = url.hostname;

		// Forbidden characters?
		if (hostname.match(/[\x00-\x2d\x2f\x3a-\x60\x7b-\xff]/))
			return false;

		// FQDN?
		const labels = hostname.split('.').reverse();

		// Trip off a possible trailing dot.
		if (labels[0] === '')
			labels.splice(0, 1);

		// Fully-qualified domain name?
		if (labels.length <= 1)
			return false;

		// Two consecutive dots?
		if (hostname.includes('..'))
			return false;

		// IPv4 address?	You can also do that with one single regular
		// expression.	Or with just one reducer.	But: Take care that you
		// treat leading zeros correctly.	10.20.30.40 is an IPv4 address
		// but 10.20.030.40 is NOT an IPv4 address but a hostname.	And,
		// of course, 10.20.300.40 is not an IPv4 address but a hostname.
		if (hostname.match(/^(?:0|(?:[1-9][0-9]{0,2})\.){3}(?:0|(?:[1-9][0-9]{0,2}))$/)) {
			const octets = hostname.split('.').map((num) => parseInt(num));
			if (octets.length === 4
				&& octets.reduce((a, b) => Math.max(a, b)) < 256)
				return false;
		}

		// We don't allow .arpa tld hostnames:
		//
		// - in-addr.arpa are IPv4 addresses which are forbidden.
		// - ip6.arpa are IPv6 addresses which are also forbidden.
		// - home.arpa is for private networks.
		//
		// And the rest of that tld probably also doesn't make sense for us.
		if ('arpa' === labels[0])
			return false;

		// RFC-2606 top-level domains.
		const rfc2606 = ['test', 'example', 'invalid', 'localhost'];
		if (rfc2606.includes(labels[0]))
			return false;

		// RFC-2606 2nd level domains.
		if (labels[1] === 'example' && ['com', 'net', 'org'].includes(labels[0]))
			return false;

		// Restrictions not checked here:
		//
		// - Some registries split their namespace into subdomains that cannot
		//	 be registered.	You can for example not register SOMETHING.uk
		//	 but only SOMETHING.SUB.uk where SUB is a list of subdomains like
		//	 'co', 'net', etc.
		// - Some registries reserve parts of their namespace for special
		//	 purposes.	For example ".b.br" is reserved for banks in Brazil.
		// - We simply assume here that all non-ASCII characters are
		//	 allowed everywhere in hostname.	But most registries only allow
		//	 a subset of Unicode characters but that subset is tld specific.
		// - Hostname software MUST support names up to 63 characters in
		//	 length and SHOULS support names up to 255 characters length.
		//	 But we allow arbitrary length hostnames here.

		// Labels must not start or end with a hyphen.	The standard also says
		// that it must not start or end with a dot but that is redundant
		// because labels must also not be empty except for the root label.
		for (let i = 0; i < labels.length; ++i)
			if (labels[i].charAt(0) === '-' || labels[i].endsWith('-'))
				return false;

		return true;
	}
}
