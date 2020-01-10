import { UrlValidator } from './urlValidator';
import { FormControl } from '@angular/forms';

interface TestCase {
	url: string;
	expected: string | null;
	msg: string;
}

describe('UrlValidator', () => {
	const schemeTestCases: TestCase[] = [
		{
			url: 'http://my.example.fr',
			expected: null,
			msg: 'http okay'
		},
		{
			url: 'https://my.example.fr',
			expected: null,
			msg: 'https okay'
		},
		{
			url: 'gopher://my.example.fr',
			expected: 'scheme',
			msg: 'gopher not okay'
		},
		{
			url: '/path/to/resource',
			expected: 'scheme',
			msg: 'schemeless not okay'
		}
	];
	for (let i = 0; i < schemeTestCases.length; ++i) {
		const tc = schemeTestCases[i];
		const expectation = tc.expected ?
			`'${tc.url}' should cause a ${tc.expected} error (${tc.msg})`
			: `'${tc.url}' should be okay (${tc.msg})`;
		let expected = tc.expected ? { [tc.expected]: true } : null;

		it(expectation, () => {
			const c = new FormControl(tc.url);
			expect(UrlValidator.scheme(c)).toEqual(expected);
		});
	}

	const portTestCases: TestCase[] = [
		{
			url: 'http://my.example.fr:65536',
			expected: 'hostname',
			msg: 'port out of range'
		},
		{
			// Port zero.
			url: 'http://my.example.fr:0',
			expected: 'hostname',
			msg: 'port zero'
		},
		{
			url: 'http://my.example.fr:-1234',
			expected: 'hostname',
			msg: 'negative port'
		},
		{
			url: 'http://my.example.fr:1234',
			expected: null,
			msg: 'port okay'
		},
		{
			url: 'http://my.example.fr:80',
			expected: null,
			msg: 'default port'
		},
	];
	for (let i = 0; i < portTestCases.length; ++i) {
		const tc = portTestCases[i];
		const expectation = tc.expected ?
			`'${tc.url}' should cause a ${tc.expected} error (${tc.msg})`
			: `'${tc.url}' should be okay (${tc.msg})`;
		let expected = tc.expected ? { [tc.expected]: true } : null;

		it(expectation, () => {
			const c = new FormControl(tc.url);
			expect(UrlValidator.hostname(c)).toEqual(expected);
		});
	}

	const hostnameTestCases: TestCase[] = [
		{
			url: 'http://my_example.fr',
			expected: 'hostname',
			msg: 'illegal character'
		},
		{
			url: 'http://my.example.fr.',
			expected: null,
			msg: 'trailing dot'
		},
		{
			url: 'http://WWW.exaMple.FR',
			expected: null,
			msg: 'case'
		},
		{
			url: 'http://whatever',
			expected: 'hostname',
			msg: 'non-fqdn'
		},
		{
			url: 'http://what..ever.com',
			expected: 'hostname',
			msg: 'consecutive dots'
		},
		{
			url: 'http://what.ever.com..',
			expected: 'hostname',
			msg: 'two trailing dots'
		},
		{
			url: 'http://4.3.2.1.in-addr.arpa',
			expected: 'hostname',
			msg: '.in-addr.arpa'
		},
		{
			url: 'http://www.example.int',
			expected: 'hostname',
			msg: '.int'
		},
		{
			url: 'http://www.пример.bg',
			expected: null,
			msg: 'utf-8 domain name'
		},
		{
			url: 'http://www.example.x-y',
			expected: 'hostname',
			msg: 'hyphen in tld'
		},
		{
			url: 'http://org.x11',
			expected: 'hostname',
			msg: 'digit in tld'
		},
		{
			url: 'http://www.xn--e1afmkfd',
			expected: null,
			msg: 'unicode tld'
		},
		{
			url: 'http://...',
			expected: 'hostname',
			msg: 'triple dot'
		},
		{
			url: 'http://..',
			expected: 'hostname',
			msg: 'double dot'
		},
		{
			url: 'http://.',
			expected: 'hostname',
			msg: 'single dot'
		},
		{
			url: 'http://1.2.3.4',
			expected: null,
			msg: 'valid IPv4'
		},
		{
			url: 'http://127.0.0.1',
			expected: 'hostname',
			msg: 'loopback'
		},
		{
			url: 'http://127.2.3.4',
			expected: 'hostname',
			msg: 'xloopback'
		},
		{
			url: 'http://10.23.4.89',
			expected: 'hostname',
			msg: 'private IPv4 10.x.x.x'
		},
		{
			url: 'http://172.23.4.89',
			expected: 'hostname',
			msg: 'private IPv4 172.x.x.x'
		},
		{
			url: 'http://192.168.169.170',
			expected: 'hostname',
			msg: 'private IPv4 192.168.x.x'
		},
		{
			url: 'http://169.254.169.170',
			expected: 'hostname',
			msg: 'link-local IPv4'
		},
		{
			url: 'http://100.65.66.67',
			expected: 'hostname',
			msg: 'carrier-grade NAT deployment IPv4'
		},
		{
			url: 'http://0x78.00000.0.0000170',
			expected: null,
			msg: 'hex/octal IPv4'
		},
		{
			url: 'http://0X00078.00000.0.0000170',
			expected: null,
			msg: 'hex/octal IPv4'
		},
		{
			url: 'http://1.2.3.08',
			expected: 'hostname',
			msg: 'invalid IPv4 with octal'
		},
		{
			url: 'http://[89ab::1234]',
			expected: null,
			msg: 'valid IPv6'
		},
		{
			url: 'http://[89ab::1234]/',
			expected: null,
			msg: 'valid IPv6 with slash'
		},
		{
			url: 'http://[89ab::1234]/foo/bar',
			expected: null,
			msg: 'valid IPv6 with path'
		},
		{
			url: 'http://[89ab::1234]:1234',
			expected: null,
			msg: 'valid IPv6 with port'
		},
		{
			url: 'http://[89ab::1234]:1234/',
			expected: null,
			msg: 'valid IPv6 with port and slash'
		},
		{
			url: 'http://[89ab::1234]:1234/foo/bar',
			expected: null,
			msg: 'valid IPv6 with port and path'
		},
		{
			url: 'http://[::]',
			expected: 'hostname',
			msg: 'unspecified IPv6 address'
		},
		{
			url: 'http://[::1]',
			expected: 'hostname',
			msg: 'loopback IPv6 address'
		},
		{
			url: 'http://[::ffff:1.2.3.4]',
			expected: 'hostname',
			msg: 'IPv6 mapped address decimal'
		},
		{
			url: 'http://[::ffff:a:b]',
			expected: 'hostname',
			msg: 'IPv6 mapped address hex'
		},
		{
			url: 'http://[::ffff:0:1.2.3.4]',
			expected: 'hostname',
			msg: 'IPv4 translated address decimal'
		},
		{
			url: 'http://[::ffff:0:a:b]',
			expected: 'hostname',
			msg: 'IPv4 translated address hex'
		},
		{
			url: 'http://[0000:0000:0000:0000:0000:0000:12.155.166.101]',
			expected: 'hostname',
			msg: 'IPv4 compatible decimal'
		},
		{
			url: 'http://[0000:0000:0000:0000:0000:0000:0C9B:A665]',
			expected: 'hostname',
			msg: 'IPv4 compatible hex'
		},
		{
			url: 'http://[64:ff9b::1.2.3.4]',
			expected: 'hostname',
			msg: 'IPv4/IPv6 address translation decimal'
		},
		{
			url: 'http://[64:ff9b::a:b]',
			expected: 'hostname',
			msg: 'IPv4/IPv6 address translation hex'
		},
		{
			url: 'http://[100::a:ffff:ffff:ffff:ffff]',
			expected: 'hostname',
			msg: 'IPv6 discard prefix'
		},
		{
			url: 'http://[2001:0:4136:E378:8000:63BF:3FFF:FDD2]',
			expected: 'hostname',
			msg: 'IPv6 Teredo'
		},
		{
			url: 'http://[2002:C9B:A665:1::C9B:A665]',
			expected: 'hostname',
			msg: '6to4 addressing scheme'
		},
		{
			url: 'http://[FD00:F53B:82E4::53]',
			expected: 'hostname',
			msg: 'IPv6 site local address'
		},
		{
			url: 'http://[FE80::5AFE:AA:20A2]',
			expected: 'hostname',
			msg: 'IPv6 link-local address'
		},
		{
			url: 'http://[FF02:AAAA:FEE5::1:3]',
			expected: 'hostname',
			msg: 'IPv6 multicast address'
		},
		{
			url: 'http://www.test',
			expected: 'hostname',
			msg: 'RFC 2606 .test'
		},
		{
			url: 'http://www.example',
			expected: 'hostname',
			msg: 'RFC 2606 .example'
		},
		{
			url: 'http://localhost',
			expected: 'hostname',
			msg: 'RFC 2606 localhost'
		},
		{
			url: 'http://www.localhost',
			expected: 'hostname',
			msg: 'RFC 2606 .localhost'
		},
		{
			url: 'http://www.invalid',
			expected: 'hostname',
			msg: 'RFC 2606 .invalid'
		},
		{
			url: 'http://www.example.com',
			expected: 'hostname',
			msg: 'RFC 2606 .example.com'
		},
		{
			url: 'http://www.example.net',
			expected: 'hostname',
			msg: 'RFC 2606 .example.net'
		},
		{
			url: 'http://www.example.org',
			expected: 'hostname',
			msg: 'RFC 2606 .example.org'
		},
		{
			url: 'http://www.example.local',
			expected: 'hostname',
			msg: 'RFC 6762 .local'
		},
		{
			url: 'http://www.example.onion',
			expected: 'hostname',
			msg: 'RFC 7686 .onion'
		},
		{
			url: 'http://www.-example.fr',
			expected: 'hostname',
			msg: 'leading hyphen'
		},
		{
			url: 'http://www.7example.fr',
			expected: 'hostname',
			msg: 'leading digit'
		},
		{
			url: 'http://www.example-.fr',
			expected: 'hostname',
			msg: 'trailing hyphen'
		},
		{
			url: 'http://www.example7.fr',
			expected: null,
			msg: 'trailing digit'
		}
	];
	for (let i = 0; i < hostnameTestCases.length; ++i) {
		const tc = hostnameTestCases[i];
		const expectation = tc.expected ?
			`'${tc.url}' should cause a ${tc.expected} error (${tc.msg})`
			: `'${tc.url}' should be okay (${tc.msg})`;
		let expected = tc.expected ? { [tc.expected]: true } : null;

		it(expectation, () => {
			const c = new FormControl(tc.url);
			expect(UrlValidator.hostname(c)).toEqual(expected);
		});
	}
});
