# Survey Application

It's a survey web application which allows user to create surveys and share survey forms to the targeted audience. 

It's used RectJs as front-end and Rails as back-end. 

This project only contain API only to download front-end follow installation steps. 
 
## Installation

Step 1: Download front-end application 


```bash
git clone https://github.com/Gauravbtc/survey-frontend.git
```

Step 2: Download back-end application 

```bash
git clone https://github.com/Gauravbtc/survey-backend.git
```

Step 3: Go to the front-end project directory and execute below cmd

```bash
npm install
```

Step 4: Go to the back-end project directory and Install requires RVM for ruby 2.7.2


Step 5: Rename sample_databse.yml to database.yml and put your database credentials

Step 6: Rename sample_secrets.yml to secrets.yml and place your react application host URL


Step 7: Do bundle install

```bash
bundle install
```

Step 8: Create a database and run migrations

```bash
rails db:create
rails db:migrate
```

Step 9: Run Rails Server 

```bash
 rails s -p 3005
```


### Go to react application host 

http://localhost:3000

