import { Component, OnInit } from '@angular/core';
import { LinguaService } from '../../../core/services/lingua.service';
import { Router } from '@angular/router';

const linguaKey = 'lingua-poly-lingua';

@Component({
	selector: 'app-lingua-selector',
	templateUrl: './lingua-selector.component.html',
	styleUrls: ['./lingua-selector.component.sass']
})
export class LinguaSelectorComponent implements OnInit {
	lingua: string;

	constructor(
		private linguaService: LinguaService,
		private router: Router,
	) { }

	ngOnInit(): void {
		const stored = this.linguaService.getLingua();
		if (stored !== null && this.linguaService.supportedLingua(stored)) {
			this.lingua = stored;
		}

		if (!this.lingua) {
			const languages = navigator.languages || [];

			console.log(languages);
			for (let i = 0; i < languages.length; ++i) {
				if (this.linguaService.supportedLingua(languages[i])) {
					this.lingua = languages[i];
					break;
				}
				if (languages[i].match(/^[a-z]{2}-/)
					&& this.linguaService.supportedLingua(languages[i].substr(0, 2))) {
					this.lingua = languages[i].substr(0, 2);
					break;
				}
			}
		}

		if (!this.lingua) this.lingua = this.linguaService.defaultLingua();

		this.linguaService.setLingua(this.lingua);

		this.router.navigate([`/${this.lingua}/main/start`]);
	}
}
