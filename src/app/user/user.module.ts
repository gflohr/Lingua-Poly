import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ProfileComponent } from './components/profile/profile.component';
import { RouterModule } from '@angular/router';
import { userRoutes } from './user.routes';

@NgModule({
	imports: [
		CommonModule,
		RouterModule.forChild(userRoutes)
	],
	declarations: [ProfileComponent]
})
export class UserModule { }
