

Github repo: https://github.com/lukevella/rallly

## Belangrijke mappen/bestanden

postgresql connecties: /var/lib/pgsql/data/pg_hba.conf
postgresql config: /var/lib/pgsql/data/postgresql.conf

omgevingsvariabelen: rallly/packages/database/prisma/.env
    > kopieren vanuit apps/web/sample.env
    > wijzigen NEXT_PUBLIC_BASE_URL, SECRET_PASSWORD en DATABASE_URL
    > DATABASE_URL is de connectiestring met de database die we aanmaken
config voor prisma: rallly/packages/database/prisma/schema.prisma
    > hier eigenlijk niets in wijzigen

## info

Connectie maken met databse lijkt niet te lukken met laatste versie van postgresql, geen idee waarom.
De connectie wordt steeds gerefused, ook na aanpassen pg_hba.conf file.
Bij postgresql14 lukt de connectie wel met dezelfde wijzigingen in pg_hba.conf.

`yarn build` runt volledig maar `yarn start`wordt niet gevonden?
`yarn dev`runt volledig => kan ook naar website rallly.thematrix.local surfen maar bij gebruik redirect hij naar de standaard website

