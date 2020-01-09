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
