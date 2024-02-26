drop policy "delete_admin" on "public"."users_groups";

drop policy "delete_self" on "public"."users_groups";

drop policy "update_admin" on "public"."users_groups";

create policy "delete_admin"
on "public"."users_groups"
as permissive
for delete
to public
using (((EXISTS ( SELECT 1
   FROM users_groups ug
  WHERE ((ug.group_id = users_groups.group_id) AND (ug.user_id = auth.uid()) AND (ug.role = 'admin'::users_groups_roles)))) AND ((role <> 'admin'::users_groups_roles) OR (( SELECT count(*) AS count
   FROM users_groups ug
  WHERE ((ug.role = 'admin'::users_groups_roles) AND (ug.group_id = users_groups.group_id))) > 1))));


create policy "delete_self"
on "public"."users_groups"
as permissive
for delete
to public
using (((user_id = auth.uid()) AND ((role <> 'admin'::users_groups_roles) OR (( SELECT count(*) AS count
   FROM users_groups ug
  WHERE ((ug.role = 'admin'::users_groups_roles) AND (ug.group_id = users_groups.group_id))) > 1))));


create policy "update_admin"
on "public"."users_groups"
as permissive
for update
to public
using ((EXISTS ( SELECT 1
   FROM users_groups ug
  WHERE ((ug.group_id = users_groups.group_id) AND (ug.user_id = auth.uid()) AND (ug.role = 'admin'::users_groups_roles)))))
with check (((role = 'admin'::users_groups_roles) OR (( SELECT count(*) AS count
   FROM users_groups ug
  WHERE ((ug.role = 'admin'::users_groups_roles) AND (ug.id <> users_groups.id) AND (ug.group_id = users_groups.group_id))) >= 1)));



