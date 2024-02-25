"use client";
import { Auth } from "@supabase/auth-ui-react";
import { ThemeSupa } from "@supabase/auth-ui-shared";
import { createClientComponentClient } from "@supabase/auth-helpers-nextjs";
import { Database } from "@/supabase";
import { useRouter } from "next/navigation";

export default function AuthForm() {
  const supabase = createClientComponentClient<Database>();
  const router = useRouter();
  supabase.auth.onAuthStateChange((event) => {
    if (event === "SIGNED_IN" || event === "SIGNED_OUT") {
      router.refresh();
    }
  });

  return (
    <div>
      <Auth
        supabaseClient={supabase}
        view="sign_in"
        theme="dark"
        appearance={{ theme: ThemeSupa }}
      />
      <Auth
        supabaseClient={supabase}
        view="sign_up"
        theme="dark"
        appearance={{ theme: ThemeSupa }}
      />
    </div>
  );
}
