# AD13 E FOOTBALL TOURNAMENT — Season 1

## Included
- `index.html`: public tournament website + manager login and dashboard.
- `setup.sql`: database tables and access policies for Supabase.

## One-time setup (about 10 minutes)
1. Create a free project at https://supabase.com/.
2. Open **SQL Editor → New query**, paste all of `setup.sql`, and run it.
3. Open **Project Settings → API**. Copy the **Project URL** and **anon/public key**.
4. Open `index.html` in a text editor. Near the top of its script, replace:
   - `PASTE_SUPABASE_PROJECT_URL` with your Project URL.
   - `PASTE_SUPABASE_ANON_KEY` with your anon/public key.
   The anon key is intended for browser use; security is enforced by the SQL row-level security policies. Never put a `service_role` key in this file.
5. In Supabase **Authentication → Users**, invite each manager by email (or create the manager accounts). Managers should use the email/password sign-in on the website.
6. In **SQL Editor**, authorise each manager by running this query once per manager, replacing the email:
   `insert into public.tournament_admins(email) values ('manager@example.com') on conflict do nothing;`
   Add as many management emails as required. Only these emails can edit the tournament.
7. Upload `index.html` to the root of your GitHub repository as `index.html` (keep the old HTML file if you want, but Pages needs `index.html`). Commit the change.
8. In GitHub repository **Settings → Pages**, select the `main` branch and `/ (root)` if not already selected.

## Using the site
- Visitors can view player slots, scores and the knockout bracket.
- Managers sign in with their invited account email/password.
- Managers can add/remove/replace players, enter scores and select a winner for a tied match.
- Changes are stored in Supabase and broadcast to visitors.

## Important
- This project is prepared but not connected to your Supabase project until you complete steps 1–6.
- Do not share your Supabase `service_role` key or manager passwords.
- Supabase Auth email/password sign-in requires users to be created/invited in Supabase first.
- This is a single Season 1 tournament. Adding or changing players resets match results to avoid stale winners.
