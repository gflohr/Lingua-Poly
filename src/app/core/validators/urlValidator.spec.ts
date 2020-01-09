import { UrlValidator } from './urlValidator';
import { FormControl } from '@angular/forms';

describe('UrlValidator', () => {
	const schemeTestCases = [
		{
			url: 'http://my.example.fr',
			expected: null,
		},
		{
			url: 'https://my.example.fr',
			expected: null,
		},
		{
			url: 'gopher://my.example.fr',
			expected: 'scheme',
		},
		{
			url: '/path/to/resource',
			expected: 'scheme',
		}
	];
	const portTestCases = [
		{
			// Port out of range.
			url: 'http://my.example.fr:65536',
			expected: 'hostname',
		},
		{
			// Port zero.
			url: 'http://my.example.fr:0',
			expected: 'hostname',
		},
		{
			// Negative port
			url: 'http://my.example.fr:-1234',
			expected: 'hostname',
		},
		{
			// Port okay.
			url: 'http://my.example.fr:1234',
			expected: null,
		}
	];

	for (let i = 0; i < schemeTestCases.length; ++i) {
		const tc = schemeTestCases[i];
		const expectation = tc.expected ?
			`'${tc.url}' should cause a ${tc.expected} error`
			: `'${tc.url}' should be okay`;
		let expected = tc.expected ? { [tc.expected]: true } : null;

		it(expectation, () => {
			const c = new FormControl(tc.url);
			expect(UrlValidator.scheme(c)).toEqual(expected);
		});
	}

	for (let i = 0; i < portTestCases.length; ++i) {
		const tc = portTestCases[i];
		const expectation = tc.expected ?
			`'${tc.url}' should cause a ${tc.expected} error`
			: `'${tc.url}' should be okay`;
		let expected = tc.expected ? { [tc.expected]: true } : null;

		it(expectation, () => {
			const c = new FormControl(tc.url);
			expect(UrlValidator.hostname(c)).toEqual(expected);
		});
	}
});
