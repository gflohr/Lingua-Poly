import { Component, OnInit } from '@angular/core';
import { UILinguaService } from '../../../core/services/ui-lingua.service';
import { Router } from '@angular/router';
import { applicationConfig } from '../../../app.config';

@Component({
	selector: 'app-lingua-selector',
	templateUrl: './lingua-selector.component.html',
	styleUrls: ['./lingua-selector.component.sass']
})
export class LinguaSelectorComponent implements OnInit {
	constructor(
		private uiLinguaService: UILinguaService,
		private router: Router,
	) {}

	ngOnInit(): void {
		let lingua: string;

		const stored = this.uiLinguaService.getLingua();
		if (stored !== null && this.uiLinguaService.supportedLingua(stored)) {
			lingua = stored;
		}

		if (!lingua) {
			const languages = navigator.languages || [];

			console.log(languages);
			for (let i = 0; i < languages.length; ++i) {
				if (this.uiLinguaService.supportedLingua(languages[i])) {
					lingua = languages[i];
					break;
				}
				if (languages[i].match(/^[a-z]{2}-/)
					&& this.uiLinguaService.supportedLingua(languages[i].substr(0, 2))) {
					lingua = languages[i].substr(0, 2);
					break;
				}
			}
		}

		if (!lingua) lingua = this.uiLinguaService.defaultLingua();

		this.uiLinguaService.setLingua(lingua);

		const language = applicationConfig.defaultLanguage;
		this.router.navigate([`/${lingua}/${language}/main/start`]);
	}
}
