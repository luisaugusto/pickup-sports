# Pickup Sports

This is an open source application for finding nearby pickup games for your favorite sports, as well as for creating groups and hosting your own games.

## Getting Started with Local Development

### Setting Up Supabase

> Running Supabase locally requires the installation of [Docker Desktop](https://docs.docker.com/desktop)

1. Run `npx supabase start` to install the Docker images and containers for the project
2. Once the project is running, it will output a list of URLs and keys for your local environment. Create a `.env.local` using `.env.example`, then set the `NEXT_PUBLIC_SUPABASE_URL` to the API Url, and `NEXT_PUBLIC_SUPABASE_ANON_KEY` to the Anon Key from your local environment
3. Run `npm run supabase-types` to generate a types file for your local database
4. When you are done with local development, you can run `npx supabase db stop` to stop all Supabase Docker containers currently running.

You can learn more about Supabase from their [documentation](https://supabase.com/docs)

#### Supabase Migrations

If you need to make changes to the database, you can do so in the local Supabase studio and then create a migration with `npx supabase diff -f <migration_name>`. This will create a file in `./supabase/migrations`, which will be deployed to production when merged into the main branch.

If there are new migrations in the repo, you can apply them to your local database with `npx supabase migration up`

### Running Client

1. Install packages locally with `npm i`
2. Start the development server with `npm run dev`

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

You can learn more about NextJS from their [documentation](https://nextjs.org/docs)
