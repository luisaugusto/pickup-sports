drop policy "insert_self" on "public"."users_groups";

create policy "insert_self"
on "public"."users_groups"
as permissive
for insert
to public
with check (((user_id = auth.uid()) AND ((role = 'member'::users_groups_roles) OR ((role = 'admin'::users_groups_roles) AND (NOT (EXISTS ( SELECT 1
   FROM users_groups ug
  WHERE (ug.group_id = users_groups.group_id))))))));



