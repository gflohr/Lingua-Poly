import { Component, OnInit } from '@angular/core';
import { UILinguaService } from '../../../core/services/ui-lingua.service';
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
		private uiLinguaService: UILinguaService,
		private router: Router,
	) { }

	ngOnInit(): void {
		const stored = this.uiLinguaService.getLingua();
		if (stored !== null && this.uiLinguaService.supportedLingua(stored)) {
			this.lingua = stored;
		}

		if (!this.lingua) {
			const languages = navigator.languages || [];

			console.log(languages);
			for (let i = 0; i < languages.length; ++i) {
				if (this.uiLinguaService.supportedLingua(languages[i])) {
					this.lingua = languages[i];
					break;
				}
				if (languages[i].match(/^[a-z]{2}-/)
					&& this.uiLinguaService.supportedLingua(languages[i].substr(0, 2))) {
					this.lingua = languages[i].substr(0, 2);
					break;
				}
			}
		}

		if (!this.lingua) this.lingua = this.uiLinguaService.defaultLingua();

		this.uiLinguaService.setLingua(this.lingua);

		this.router.navigate([`/${this.lingua}/fi/main/start`]);
	}
}
