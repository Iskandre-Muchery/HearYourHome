import { Component, OnInit } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { Observable, Subscription } from 'rxjs';
import { User } from 'src/app/models/user.model';
import { AuthentificationService } from 'src/app/services/authentification/authentification.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {

  loginForm = new FormGroup({
    email: new FormControl('', Validators.required),
    password: new FormControl('', Validators.required),
  });

  private subscriptions: Subscription[] = [];

  constructor(
    private authentificationService: AuthentificationService,
    private router: Router,
  ) {

  }

  ngOnInit(): void {
  }

  login(): void {
    if (this.loginForm.valid) {
      this.subscriptions.push(
        this.authentificationService.sendLogin(this.loginForm.value).subscribe(
          data => {
            this.router.navigate(['/dashboard']);
          },
          error => console.error(error)
        )
      );
    }
  }

  goToRegister(): void {
    this.router.navigate(['/register']);
  }

}
