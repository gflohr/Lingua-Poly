import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { LinguaSelectorComponent } from './components/lingua-selector/lingua-selector.component';
import { EffectsModule } from '@ngrx/effects';
import { LinguaEffects } from './lingua.effects';

@NgModule({
	declarations: [LinguaSelectorComponent],
	imports: [
		CommonModule,
		EffectsModule.forFeature([LinguaEffects]),
	]
})
export class LinguaModule { }
