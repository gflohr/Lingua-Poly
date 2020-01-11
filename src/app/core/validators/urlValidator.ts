import { AbstractControl, ValidationErrors } from '@angular/forms';

export class UrlValidator {
	static hostname(control: AbstractControl): ValidationErrors | null {
		if (!control.value.length) return null;

		try {
			const url = new URL(control.value);
			if (!(UrlValidator.checkPort(url)
				&& UrlValidator.checkHostname(url))) {
					return { hostname: true };
			}
		} catch (e) {
			return { hostname: true };
		}

		return null;
	}

	static scheme(control: AbstractControl): ValidationErrors | null {
		if (!control.value.length) return null;

		try {
			const url = new URL(control.value);
			if (!['https:', 'http:'].includes(url.protocol)) return { scheme: true };
		} catch (e) {
			return { scheme: true };
		}

		return null;
	}

	private static checkPort(url: URL): boolean {
		return url.port !== '0';
	}

	private static checkHostname(url: URL): boolean {
		// Only allow http and https URLs.
		if ('https:' !== url.protocol && 'http:' !== url.protocol) {
			return false;
		}

		// Do not allow username or password information.
		if (url.username !== '' || url.password !== '') {
			return false;
		}

		// Split the hostname into labels.
		let labels = url.hostname.split('.');

		// Discard an empty root label.
		if (labels[labels.length - 1] === '') {
			labels.pop();
		}

		// Otherwise empty labels are illegal.  Note that in Javascript, this
		// also filters out the illegal hostname "." like in "https://.".
		if (labels.filter(label => label === '').length) {
			return false;
		}

		// Numerical IPv4 address?
		let isIP = false;
		if (labels.length === 4) {
			// In Perl this is more complicated because it does not normalize
			// labels like "0177" or "0x7f" to decimal numbers.
			const octetRe = new RegExp('^(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$');
			if (labels.filter(label => !!label.match(octetRe)).length === 4) {
				isIP = true;
				const octets = labels.map(octet => parseInt(octet, 10));

				// IPv4 addresses with special purpose?
				if (// Loopback.
					octets[0] === 127
					// Private IP ranges.
					|| octets[0] === 10
					|| (octets[0] === 172 && octets[1] >= 16 && octets[1] <= 31)
					|| (octets[0] === 192 && octets[1] === 168)
					// Carrier-grade NAT deployment.
					|| (octets[0] === 100 && octets[1] >= 64 && octets[1] <= 127)
					// Link-local addresses.
					|| (octets[0] === 169 && octets[1] === 254)) {
					return false;
				}
			}
		} else if (!!url.hostname.match(/^\[([0-9a-fA-F:]+)\]$/)
				&& !!url.hostname.match(/:/)) {
			// Uncompress the IPv6 address.
			let groups = url.hostname.substr(1, url.hostname.length - 2).split(':');
			if (groups.length < 8) {
				for (let i = 0; i < groups.length; ++i) {
					if (groups[i] === '') {
						groups[i] = '0';
						let missing = 7 - groups.length;
						for (let j = 0; j <= missing; ++j) {
							groups.splice(i, 0, '0');
						}
						break;
					}
				}
			}

			// Check it.
			if (groups.filter(group => group.match(/^[0-9a-f]+$/)).length === 8) {
				const igroups = groups.map(group => parseInt(group, 16));
				const max = igroups.reduce((a, b) => Math.max(a, b));

				if (max <= 0xffff) {
					isIP = true;
					const norm = groups.map(group => group.padStart(4, '0')).join(':');
					if (max === 0 // the unspecified address
						// Loopback.
						|| '0000:0000:0000:0000:0000:00000:0000:0001' === norm
						// IPv4 mapped addresses.
						|| !!norm.match(/^0000:0000:0000:0000:0000:ffff/)
						// IPv4 translated addresses.
						|| !!norm.match(/^0000:0000:0000:0000:ffff:0000/)
						// IPv4/IPv6 address translation.
						|| !!norm.match(/^0064:ff9b:0000:0000:0000:0000/)
						// IPv4 compatible.
						|| !!norm.match(/^0000:0000:0000:0000:0000:0000/)
						// Discard prefix.
						|| !!norm.match(/^0100/)
						// Teredo tunneling, ORCHIDv2, documentation, 6to4.
						|| !!norm.match(/^200[12]/)
						// Private networks.
						|| !!norm.match(/^f[cd]/)
						// Link-local
						|| !!norm.match(/^fe[89ab]/)
						// Multicast.
						|| !!norm.match(/^ff/)
					) {
						return false;
					}
				}
			}
		}

		if (isIP) return true;

		// Only fully-qualified domain names?
		if (labels.length < 2) {
			return false;
		}

		// But what about hostnames like 'co.uk' or 'b.br'?

		// The top-level domain name must not contain a hyphen or digit unless it
		// is an IDN.
		const tld = labels[labels.length - 1];
		if ('xn--' !== tld.substr(0, 4) && !!tld.match(/[-0-9]/)) {
			return false;
		}

		// RFC 2606, RFC6762, RFC7686, and special purpose domains
		// (.arpa, .int) or recommended for private use (.home, .corp).
		if ([
			'example',
			'test',
			'localhost',
			'invalid',
			'local',
			'onion',
			'home',
			'corp',
			'arpa',
			'int'].includes(tld)
		    || ('example' === labels[labels.length - 2]
		        && ['com', 'net', 'org'].includes(tld))) {
			return false;
		}

		// Some people say that a top-level domain must be at least two
		// characters long.  But there's no evidence for that.

		// Leading hyphens or digits, and trailing hyphens are not allowed.
		for (let i = 0; i < labels.length; ++i) {
			const label = labels[i];
			if (!!label.match(/^[-0-9]/) || !!label.match(/-$/)) {
				return false;
			}
		}

		// Unicode.  We allow all characters except the forbidden ones in the
		// ASCII range.
		if (!!url.hostname.match(/[\x00-\x2c\x2f\x3a-\x60\x7b-\x7f]/)) {
			return false;
		}

		return true;
	}
}
