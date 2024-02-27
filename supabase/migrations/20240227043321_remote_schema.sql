drop policy "select_admin_moderators" on "public"."users_groups";

alter table "public"."events" drop column "banner_url";

alter table "public"."events" add column "banner_image_url" text;

alter table "public"."events" add column "rsvp_start_date" timestamp with time zone;

alter table "public"."groups" add column "banner_image_url" text;

alter table "public"."groups" add column "description" text not null;

alter table "public"."groups" add column "is_public" boolean not null;

alter table "public"."groups" add column "name" text not null;

alter table "public"."groups" add column "require_approvals" boolean not null;

alter table "public"."groups" add column "updated_at" timestamp with time zone not null default now();

alter table "public"."users_events" add column "group_id" bigint not null;

alter table "public"."users_events" add constraint "public_users_events_group_id_fkey" FOREIGN KEY (group_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."users_events" validate constraint "public_users_events_group_id_fkey";

create policy "Allow event creation if user is higher than member role"
on "public"."events"
as permissive
for insert
to public
with check ((EXISTS ( SELECT 1
   FROM users_groups ug
  WHERE ((ug.group_id = events.group_id) AND (ug.user_id = auth.uid()) AND (ug.role <> 'member'::users_groups_roles)))));


create policy "Allow event deletion."
on "public"."events"
as permissive
for delete
to public
using (((creator_id = auth.uid()) OR (host_id = auth.uid()) OR (EXISTS ( SELECT 1
   FROM users_groups ug
  WHERE ((ug.group_id = events.group_id) AND (ug.user_id = auth.uid()) AND (ug.role = ANY (ARRAY['moderator'::users_groups_roles, 'admin'::users_groups_roles])))))));


create policy "Allow event updates."
on "public"."events"
as permissive
for select
to public
using (((creator_id = auth.uid()) OR (host_id = auth.uid()) OR (EXISTS ( SELECT 1
   FROM users_groups ug
  WHERE ((ug.group_id = events.group_id) AND (ug.user_id = auth.uid()) AND (ug.role = ANY (ARRAY['moderator'::users_groups_roles, 'admin'::users_groups_roles])))))));


create policy "Allow reading events if user is in the event's group."
on "public"."events"
as permissive
for select
to public
using ((EXISTS ( SELECT 1
   FROM users_groups ug
  WHERE ((ug.user_id = auth.uid()) AND (ug.group_id = events.group_id)))));


create policy "Restrict read access to events based on group's public status."
on "public"."events"
as permissive
for select
to public
using ((EXISTS ( SELECT 1
   FROM groups
  WHERE ((groups.id = events.group_id) AND (groups.is_public = true)))));


create policy "Allow all users to read records from groups table."
on "public"."groups"
as permissive
for select
to public;


create policy "Allow creation when auth user is not null."
on "public"."groups"
as permissive
for insert
to public
with check ((auth.uid() IS NOT NULL));


create policy "Allow deletion if user is admin."
on "public"."groups"
as permissive
for delete
to public
using ((EXISTS ( SELECT 1
   FROM users_groups
  WHERE ((users_groups.group_id = groups.id) AND (users_groups.user_id = auth.uid()) AND (users_groups.role = 'admin'::users_groups_roles)))));


create policy "Allow update if user is admin."
on "public"."groups"
as permissive
for update
to public
using ((EXISTS ( SELECT 1
   FROM users_groups
  WHERE ((users_groups.group_id = groups.id) AND (users_groups.user_id = auth.uid()) AND (users_groups.role = 'admin'::users_groups_roles)))));


create policy "Allow creation if auth user is not null."
on "public"."locations"
as permissive
for insert
to public
with check ((auth.uid() IS NOT NULL));


create policy "Allow reading all locations."
on "public"."locations"
as permissive
for select
to public;


create policy "Allow event RSVPs if user in group"
on "public"."users_events"
as permissive
for insert
to public
with check ((EXISTS ( SELECT 1
   FROM users_groups g
  WHERE ((g.user_id = auth.uid()) AND (g.group_id = users_events.group_id)))));


create policy "Allow reading event RSVPs if group is public"
on "public"."users_events"
as permissive
for select
to public
using ((EXISTS ( SELECT 1
   FROM groups g
  WHERE ((g.is_public = true) AND (g.id = users_events.group_id)))));


create policy "Allow reading event RSVPs if user is in the event's group."
on "public"."users_events"
as permissive
for select
to public
using ((EXISTS ( SELECT 1
   FROM users_groups ug
  WHERE ((ug.user_id = auth.uid()) AND (ug.group_id = users_events.group_id)))));


create policy "Allow users or admins / mods to update RSVPs"
on "public"."users_events"
as permissive
for update
to public
using (((user_id = auth.uid()) OR (EXISTS ( SELECT 1
   FROM users_groups ug
  WHERE ((ug.group_id = users_events.group_id) AND (ug.user_id = auth.uid()) AND (ug.role = ANY (ARRAY['moderator'::users_groups_roles, 'admin'::users_groups_roles])))))))
with check (true);


create policy "select_admin_moderator"
on "public"."users_groups"
as permissive
for select
to public
using ((EXISTS ( SELECT 1
   FROM users_groups ug
  WHERE ((ug.user_id = auth.uid()) AND (ug.group_id = users_groups.group_id) AND (ug.role = ANY (ARRAY['admin'::users_groups_roles, 'moderator'::users_groups_roles]))))));



