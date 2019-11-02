import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { authRoutes } from './auth.routes';
import { LoginComponent } from './components/login/login.component';
import { RegisterComponent } from './components/register/register.component';
import { ReactiveFormsModule, FormsModule } from '@angular/forms';

@NgModule({
	imports: [
		CommonModule,
		RouterModule.forChild(authRoutes),
		FormsModule,
		ReactiveFormsModule
	],
	declarations: [LoginComponent, RegisterComponent]
})
export class AuthModule { }
