import { Component, OnInit } from '@angular/core';

const linguaKey = 'lingua-poly-lingua';

@Component({
	selector: 'app-lingua-selector',
	templateUrl: './lingua-selector.component.html',
	styleUrls: ['./lingua-selector.component.sass']
})
export class LinguaSelectorComponent implements OnInit {
	lingua: string;

	constructor() { }

	ngOnInit(): void {
		const supported = ['en', 'de'];

		const stored = localStorage.getItem(linguaKey);
		if (supported.includes(stored)) {
			this.lingua = stored;
		}

		if (!this.lingua) {
			const languages = navigator.languages || [];

			console.log(languages);
			for (let i = 0; i < languages.length; ++i) {
				if (supported.includes(languages[i])) {
					this.lingua = languages[i];
					break;
				}
				if (languages[i].match(/^[a-z]{2}-/)
					&& supported.includes(languages[i].substr(0, 2))) {
					this.lingua = languages[i].substr(0, 2);
					break;
				}
			}
		}

		if (!this.lingua) this.lingua = supported[0];

		localStorage.setItem(linguaKey, this.lingua);

		console.log(`selected language: ${this.lingua}`);
	}
}
