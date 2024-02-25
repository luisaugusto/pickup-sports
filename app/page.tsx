import styles from "./page.module.css";
import AuthForm from "@/app/AuthForm";
import { createServerComponentClient } from "@supabase/auth-helpers-nextjs";
import { Database } from "@/supabase";
import { cookies } from "next/headers";

export default async function Home() {
  const supabase = createServerComponentClient<Database>({ cookies });

  const {
    data: { user },
  } = await supabase.auth.getUser();

  console.log(user);
  return (
    <main className={styles.main}>
      {user ? (
        <form action="/auth/signout" method="post">
          <button className="button block" type="submit">
            Sign out
          </button>
        </form>
      ) : (
        <AuthForm />
      )}
    </main>
  );
}
