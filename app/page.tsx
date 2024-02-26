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
  return (
    <main className={styles.main}>
      <AuthForm user={user} />
    </main>
  );
}
